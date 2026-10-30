
document.addEventListener("DOMContentLoaded", () => {
    const reader = document.getElementById("pdfReader");

    if (!reader || typeof pdfjsLib === "undefined") {
        showError("The PDF reader could not be initialized. Please reload the page.");
        return;
    }

    const pdfUrl = reader.dataset.pdfUrl;
    const progressApiUrl = reader.dataset.progressApiUrl;
    const initialPage = Math.max(
        1,
        parseInt(reader.dataset.initialPage || "1", 10)
    );

    const canvas = document.getElementById("pdfCanvas");
    const ctx = canvas.getContext("2d");

    const viewport = document.getElementById("pdfViewport");
    const loadingMessage = document.getElementById("loadingMessage");
    const errorBox = document.getElementById("readerError");
    const saveStatus = document.getElementById("saveStatus");

    const prevButton = document.getElementById("prevPage");
    const nextButton = document.getElementById("nextPage");
    const pageInput = document.getElementById("pageNumber");
    const totalPagesLabel = document.getElementById("totalPages");

    const zoomOutButton = document.getElementById("zoomOut");
    const zoomInButton = document.getElementById("zoomIn");
    const fitWidthButton = document.getElementById("fitWidth");
    const zoomLevelLabel = document.getElementById("zoomLevel");

    const progressText = document.getElementById("progressText");
    const progressBar = document.getElementById("progressBar");
    const progressFill = document.getElementById("progressFill");

    let pdfDocument = null;
    let currentPage = 1;
    let totalPages = 0;
    let zoom = 1;
    let renderTask = null;
    let renderVersion = 0;
    let saveTimer = null;
    let saveQueue = Promise.resolve();
    let isRendering = false;
    let fitToWidth = true;

    function showError(message) {
        errorBox.textContent = message;
        errorBox.hidden = false;
        loadingMessage.hidden = true;
    }

    function setStatus(message) {
        saveStatus.textContent = message;
    }

    function updateControls() {
        pageInput.value = currentPage;
        pageInput.max = totalPages;

        prevButton.disabled = currentPage <= 1;
        nextButton.disabled = currentPage >= totalPages;

        const percentage = totalPages
            ? Math.round((currentPage / totalPages) * 100)
            : 0;

        progressText.textContent = `${percentage}%`;
        progressFill.style.width = `${percentage}%`;
        progressBar.setAttribute("aria-valuenow", percentage);
    }

    async function renderPage(pageNumber) {
        if (!pdfDocument) return;

        const requestedPage = Math.min(
            Math.max(1, pageNumber),
            totalPages
        );

        currentPage = requestedPage;
        updateControls();

        const thisRender = ++renderVersion;

        // Cancel an older render if the user changes pages quickly.
        if (renderTask) {
            try {
                renderTask.cancel();
            } catch (_) {
                // The previous task may already have completed.
            }
            renderTask = null;
        }

        isRendering = true;

        try {
            const page = await pdfDocument.getPage(requestedPage);

            if (thisRender !== renderVersion) return;

            const baseViewport = page.getViewport({ scale: 1 });

            let scale = zoom;

            if (fitToWidth) {
                const availableWidth = Math.max(
                    250,
                    viewport.clientWidth - 32
                );
                scale = Math.min(2.5, availableWidth / baseViewport.width);
            }

            const devicePixelRatio = window.devicePixelRatio || 1;
            const pageViewport = page.getViewport({ scale });

            canvas.width = Math.floor(
                pageViewport.width * devicePixelRatio
            );
            canvas.height = Math.floor(
                pageViewport.height * devicePixelRatio
            );

            canvas.style.width = `${pageViewport.width}px`;
            canvas.style.height = `${pageViewport.height}px`;

            ctx.setTransform(
                devicePixelRatio, 0,
                0, devicePixelRatio,
                0, 0
            );

            renderTask = page.render({
                canvasContext: ctx,
                viewport: pageViewport
            });

            await renderTask.promise;

            if (thisRender !== renderVersion) return;

            loadingMessage.hidden = true;
            errorBox.hidden = true;

            zoomLevelLabel.textContent = `${Math.round(scale * 100)}%`;

            updateControls();
            scheduleProgressSave();

        } catch (error) {
            if (error && error.name === "RenderingCancelledException") {
                return;
            }

            console.error("PDF page rendering failed:", error);
            showError("This page could not be displayed. Please try again.");
        } finally {
            if (thisRender === renderVersion) {
                renderTask = null;
                isRendering = false;
            }
        }
    }

    function scheduleProgressSave() {
        if (!progressApiUrl || !totalPages) return;

        clearTimeout(saveTimer);
        setStatus("Unsaved changes");

        saveTimer = setTimeout(() => {
            saveProgress();
        }, 700);
    }

    function saveProgress() {
        if (!progressApiUrl || !totalPages) return;

        const payload = {
            current_page: currentPage,
            total_pages: totalPages
        };

        // Serialize requests so older page updates cannot finish last.
        saveQueue = saveQueue
            .catch(() => {})
            .then(async () => {
                setStatus("Saving progress...");

                const response = await fetch(progressApiUrl, {
                    method: "POST",
                    credentials: "same-origin",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) {
                    throw new Error(`Progress save failed (${response.status})`);
                }

                setStatus("Progress saved");
            })
            .catch(error => {
                console.error("Could not save reading progress:", error);
                setStatus("Progress could not be saved");
            });
    }

    prevButton.addEventListener("click", () => {
        if (currentPage > 1) {
            renderPage(currentPage - 1);
        }
    });

    nextButton.addEventListener("click", () => {
        if (currentPage < totalPages) {
            renderPage(currentPage + 1);
        }
    });

    pageInput.addEventListener("change", () => {
        const requested = parseInt(pageInput.value, 10);

        if (!Number.isFinite(requested)) {
            pageInput.value = currentPage;
            return;
        }

        renderPage(requested);
    });

    pageInput.addEventListener("keydown", event => {
        if (event.key === "Enter") {
            pageInput.blur();
        }
    });

    zoomInButton.addEventListener("click", () => {
        fitToWidth = false;
        zoom = Math.min(3, zoom + 0.15);
        renderPage(currentPage);
    });

    zoomOutButton.addEventListener("click", () => {
        fitToWidth = false;
        zoom = Math.max(0.4, zoom - 0.15);
        renderPage(currentPage);
    });

    fitWidthButton.addEventListener("click", () => {
        fitToWidth = true;
        renderPage(currentPage);
    });

    let resizeTimer;

    window.addEventListener("resize", () => {
        if (!pdfDocument || !fitToWidth) return;

        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(() => renderPage(currentPage), 150);
    });

    async function initializeReader() {
        if (!pdfUrl) {
            showError("No PDF file URL was provided for this book.");
            return;
        }

        try {
            const loadingTask = pdfjsLib.getDocument({
                url: pdfUrl,
                withCredentials: true
            });

            pdfDocument = await loadingTask.promise;
            totalPages = pdfDocument.numPages;

            totalPagesLabel.textContent = totalPages;
            pageInput.max = totalPages;

            // Start from the saved page, if it is valid.
            currentPage = Math.min(initialPage, totalPages);

            updateControls();
            await renderPage(currentPage);

        } catch (error) {
            console.error("Could not load PDF:", error);

            showError(
                "The PDF could not be loaded. Check that the file URL is " +
                "accessible to your website and that PDF access permissions " +
                "and cross-origin settings are configured correctly."
            );
        }
    }

    // Save the current page when the user leaves the reader.
    window.addEventListener("pagehide", () => {
        if (saveTimer) {
            clearTimeout(saveTimer);
            saveTimer = null;
            saveProgress();
        }
    });

    initializeReader();
});
