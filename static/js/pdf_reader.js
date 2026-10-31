
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

    // ---------------- AUDIOBOOK CONTROLS ----------------

    // Create audio controls dynamically
    const audioPanel = document.createElement("section");
    audioPanel.className = "reader-audio-panel";

    audioPanel.innerHTML = `
        <div class="audio-heading">
            <div>
                <h2>Listen to this book</h2>
                <p id="audioStatus">Ready to listen</p>
            </div>
            <span class="audio-icon">♫</span>
        </div>

        <div class="audio-controls">
            <button id="audioBackward" type="button">↶ 15 sec</button>
            <button id="audioPlay" type="button">▶ Play</button>
            <button id="audioForward" type="button">15 sec ↷</button>
            <button id="audioPause" type="button" disabled>Ⅱ Pause</button>
            <button id="audioStop" type="button" disabled>■ Stop</button>

            <label>
                Speed
                <select id="speechRate">
                    <option value="0.5">0.5×</option>
                    <option value="0.75">0.75×</option>
                    <option value="1" selected>1×</option>
                    <option value="1.25">1.25×</option>
                    <option value="1.5">1.5×</option>
                    <option value="1.75">1.75×</option>
                    <option value="2">2×</option>
                </select>
            </label>
        </div>

        
    `;

    const toolbar = reader.querySelector(".reader-toolbar");

    if (toolbar) {
        toolbar.insertAdjacentElement("afterend", audioPanel);
    }

    // Add audio player styling
    const audioStyle = document.createElement("style");

    audioStyle.textContent = `
        .reader-audio-panel {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin: 15px 0;
            padding: 18px;
            background: var(--reader-surface);
            color: var(--reader-text);
            border: 1px solid var(--reader-border);
            border-radius: 14px;
            box-shadow: var(--reader-shadow);
        }

        .audio-heading h2 {
            margin: 0;
            font-size: 16px;
        }

        .audio-heading p {
            margin: 5px 0;
            color: var(--reader-muted);
            font-size: 12px;
        }

        .audio-icon {
            font-size: 25px;
            color: var(--reader-primary);
        }

        .audio-controls {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
        }

        .audio-controls label {
            color: var(--reader-muted);
            font-size: 13px;
        }

        .audio-controls select {
            padding: 9px;
            border-radius: 8px;
            background: var(--reader-bg);
            color: var(--reader-text);
            border: 1px solid var(--reader-border);
        }

        #audioPlay {
            background: var(--reader-primary);
            color: white;
        }

        .audio-note {
            width: 100%;
            margin: 0;
            color: var(--reader-muted);
            font-size: 12px;
        }
    `;

    document.head.appendChild(audioStyle);

    // Get audio elements
    const audioPlay = document.getElementById("audioPlay");
    const audioPause = document.getElementById("audioPause");
    const audioStop = document.getElementById("audioStop");
    const speechRate = document.getElementById("speechRate");
    const audioStatus = document.getElementById("audioStatus");
    const audioBackward = document.getElementById("audioBackward");
    const audioForward = document.getElementById("audioForward");

    // Audio state
    let audioActive = false;
    let audioPaused = false;
    let audioPage = 1;
    let audioChunks = [];
    let audioChunkIndex = 0;
    let audioRunId = 0;

    let audioCharPosition = 0;
    let audioChunkStart = 0;
    let audioFullText = "";

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

    // ---------------- TEXT-TO-SPEECH ----------------

    function updateAudioButtons() {
        audioPlay.disabled = audioActive && !audioPaused;
        audioPause.disabled = !audioActive;
        audioStop.disabled = !audioActive;

        audioPause.textContent = audioPaused
            ? "▶ Resume"
            : "Ⅱ Pause";
    }

    // Split long PDF text into smaller chunks
    function splitText(text, maxLength = 1400) {
        const sentences = text.match(/[^.!?]+[.!?]+|[^.!?]+$/g) || [text];

        const chunks = [];
        let current = "";

        sentences.forEach(sentence => {
            sentence = sentence.trim();

            if (!sentence) return;

            if (current.length + sentence.length > maxLength && current) {
                chunks.push(current);
                current = "";
            }

            current += " " + sentence;
        });

        if (current.trim()) {
            chunks.push(current.trim());
        }

        return chunks;
    }

    // Stop audio
    function stopAudio() {
        audioRunId++;

        window.speechSynthesis.cancel();

        audioActive = false;
        audioPaused = false;

        audioChunks = [];
        audioChunkIndex = 0;
        audioFullText = "";
        audioCharPosition = 0;
        audioChunkStart = 0;

        updateAudioButtons();
        audioStatus.textContent = "Audio stopped";
    }

    // Extract text from a PDF page
    async function loadAudioPage(pageNumber, runId) {
        try {
            const page = await pdfDocument.getPage(pageNumber);
            const textContent = await page.getTextContent();

            if (runId !== audioRunId || !audioActive || audioPaused) return;

            const text = textContent.items
                .map(item => item.str || "")
                .join(" ")
                .replace(/\s+/g, " ")
                .trim();

            audioPage = pageNumber;
            currentPage = pageNumber;

            // Automatically display the page being read.
            await renderPage(pageNumber);

            if (runId !== audioRunId || !audioActive || audioPaused) return;

            audioFullText = text;
            audioCharPosition = 0;
            audioChunkStart = 0;

            if (!text) {
                audioStatus.textContent =
                    `No readable text on page ${pageNumber}. Skipping...`;

                speakNextChunk(runId, true);
                return;
            }

            audioChunks = splitText(text);
            audioChunkIndex = 0;

            speakNextChunk(runId);

        } catch (error) {
            console.error("Audio text extraction failed:", error);
            stopAudio();
            audioStatus.textContent = "Could not read this PDF page.";
        }
    }

    // Speak text and move to the next page
    function speakNextChunk(runId, skipPage = false) {

        if (runId !== audioRunId || !audioActive || audioPaused) return;

        if (!skipPage && audioChunkIndex < audioChunks.length) {
            const chunk = audioChunks[audioChunkIndex];

            const utterance = new SpeechSynthesisUtterance(
                chunk.slice(audioCharPosition - audioChunkStart)
            );

            utterance.rate = Number(speechRate.value);

            const utteranceStart = audioCharPosition;

            utterance.onboundary = event => {
                if (runId !== audioRunId || audioPaused) return;

                audioCharPosition = utteranceStart + event.charIndex;
            };

            // Browser automatically chooses its default available voice.

            utterance.onend = () => {
                if (runId !== audioRunId || audioPaused) return;

                audioCharPosition = audioChunkStart + chunk.length;
                audioChunkIndex++;

                if (audioChunkIndex < audioChunks.length) {
                    audioChunkStart += chunk.length + 1;
                    audioCharPosition = audioChunkStart;
                }

                speakNextChunk(runId);
            };

            utterance.onerror = error => {
                if (runId !== audioRunId) return;
                console.error("Speech error:", error);
                stopAudio();
                audioStatus.textContent = "Audio playback failed.";
            };

            window.speechSynthesis.speak(utterance);

            audioStatus.textContent =
                `Playing page ${audioPage} of ${totalPages}`;

            return;
        }

        const nextPage = audioPage + 1;

        if (nextPage > totalPages) {
            audioActive = false;
            audioPaused = false;

            updateAudioButtons();

            audioStatus.textContent = "You have reached the end of the book.";

            scheduleProgressSave();
            return;
        }

        loadAudioPage(nextPage, runId);
    }

    function skipAudio(seconds) {
        if (!audioActive || !audioFullText) return;

        const charactersPerSecond = 15 * Number(speechRate.value);

        const movement = Math.round(seconds * charactersPerSecond);

        const targetPosition = Math.max(
            0,
            Math.min(
                audioFullText.length,
                audioCharPosition + movement
            )
        );

        // Find the chunk containing the new position.
        let position = 0;

        for (let i = 0; i < audioChunks.length; i++) {
            const chunkEnd = position + audioChunks[i].length;

            if (targetPosition <= chunkEnd || i === audioChunks.length - 1) {
                audioChunkIndex = i;
                audioChunkStart = position;
                audioCharPosition = Math.min(targetPosition, chunkEnd);
                break;
            }

            position = chunkEnd + 1;
        }

        const wasPaused = audioPaused;

        // Cancel current speech and start from the new position.

        audioRunId++;
        const runId = audioRunId;

        window.speechSynthesis.cancel();

        audioPaused = false;

        if (wasPaused) {
            audioPaused = false;
        }

        speakNextChunk(runId);

        if (wasPaused) {
            window.speechSynthesis.pause();
            audioPaused = true;
        }

        updateAudioButtons();
    }

    // Play or resume audio
    function startAudio() {

        if (!pdfDocument) {
            audioStatus.textContent = "Please wait for the PDF to load.";
            return;
        }

        if (!("speechSynthesis" in window)) {
            audioStatus.textContent = "Your browser does not support Text-to-Speech.";
            return;
        }

        // Resume paused audio
        if (audioActive && audioPaused) {
            audioPaused = false;

            window.speechSynthesis.resume();

            updateAudioButtons();

            audioStatus.textContent = `Playing page ${audioPage}`;

            return;
        }

        if (audioActive) return;

        window.speechSynthesis.cancel();

        audioRunId++;

        const runId = audioRunId;

        audioActive = true;
        audioPaused = false;

        audioPage = currentPage;
        audioChunkIndex = 0;
        audioChunks = [];

        updateAudioButtons();

        loadAudioPage(audioPage, runId);
    }

    // Play button
    audioPlay.addEventListener("click", startAudio);

    // Pause / Resume button
    audioPause.addEventListener("click", () => {

        if (!audioActive) return;

        if (audioPaused) {
            audioPaused = false;
            window.speechSynthesis.resume();

            audioStatus.textContent = `Playing page ${audioPage}`;

        } else {
            audioPaused = true;
            window.speechSynthesis.pause();

            audioStatus.textContent = "Audio paused";
        }

        updateAudioButtons();
    });

    // Stop button
    audioStop.addEventListener("click", stopAudio);

    audioBackward.addEventListener("click", () => {
        skipAudio(-15);
    });

    audioForward.addEventListener("click", () => {
        skipAudio(15);
    });

    updateAudioButtons();

    // -----------------------------------------------

    prevButton.addEventListener("click", () => {
        if (currentPage <= 1) return;

        if (audioActive) {
            const wasPaused = audioPaused;

            audioRunId++;
            window.speechSynthesis.cancel();

            audioPage = currentPage - 1;
            audioPaused = false;

            updateAudioButtons();

            loadAudioPage(audioPage, audioRunId).then(() => {
                if (wasPaused && audioActive) {
                    audioPaused = true;
                    window.speechSynthesis.pause();
                    updateAudioButtons();
                    audioStatus.textContent = "Audio paused";
                }
            });

            return;
        }

        renderPage(currentPage - 1);
    });

    nextButton.addEventListener("click", () => {
        if (currentPage >= totalPages) return;

        if (audioActive) {
            audioRunId++;
            window.speechSynthesis.cancel();

            audioPage = currentPage + 1;
            audioPaused = false;

            updateAudioButtons();
            loadAudioPage(audioPage, audioRunId);
            return;
        }

        renderPage(currentPage + 1);
    });

    pageInput.addEventListener("change", async () => {
        const requested = parseInt(pageInput.value, 10);

        if (!Number.isFinite(requested)) {
            pageInput.value = currentPage;
            return;
        }

        const targetPage = Math.min(
            Math.max(1, requested),
            totalPages
        );

        if (audioActive) {
            const wasPaused = audioPaused;

            audioRunId++;
            const runId = audioRunId;

            window.speechSynthesis.cancel();

            audioPage = targetPage;
            audioPaused = false;

            updateAudioButtons();

            await loadAudioPage(audioPage, runId);

            if (wasPaused && audioActive && runId === audioRunId) {
                audioPaused = true;
                window.speechSynthesis.pause();
                updateAudioButtons();
                audioStatus.textContent = "Audio paused";
            }

        } else {
            renderPage(targetPage);
        }
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
