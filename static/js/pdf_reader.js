document.addEventListener("DOMContentLoaded", () => {
    const reader = document.getElementById("pdfReader");

    if (!reader || typeof pdfjsLib === "undefined") {
        const box = document.getElementById("readerError");
        if (box) {
            box.textContent = "The PDF reader could not be initialized. Please reload the page.";
            box.hidden = false;
        }
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
    let currentViewport = null; // PDF.js viewport of the page on screen

    // ---------------- PAGE WRAPPER + HIGHLIGHT LAYER ----------------
    // The canvas gets a wrapper so a transparent layer can sit exactly on top
    // of it. The reading highlight is drawn in that layer.

    const pageWrap = document.createElement("div");
    pageWrap.className = "pdf-page-wrap";
    canvas.parentNode.insertBefore(pageWrap, canvas);
    pageWrap.appendChild(canvas);

    const highlightLayer = document.createElement("div");
    highlightLayer.className = "tts-highlight-layer";
    highlightLayer.setAttribute("aria-hidden", "true");
    pageWrap.appendChild(highlightLayer);

    // ---------------- AUDIOBOOK CONTROLS ----------------

    const audioPanel = document.createElement("section");
    audioPanel.className = "reader-audio-panel";

    audioPanel.innerHTML = `
        <div class="audio-heading">
            <div>
                <h2>Listen to this book</h2>
                <p id="audioStatus">Press Play, or click any line on the page to start from there</p>
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

            <label>
                Voice
                <select id="voiceSelect" aria-label="Reading voice">
                    <option value="">Default voice</option>
                </select>
            </label>

            <label>
                Highlight
                <select id="highlightMode" aria-label="Reading highlight">
                    <option value="both">Word + line</option>
                    <option value="word">Word only</option>
                    <option value="line">Line only</option>
                    <option value="off">Off</option>
                </select>
            </label>

            <label>
                <input type="checkbox" id="autoScroll" checked>
                Auto-scroll
            </label>
        </div>

        <p class="audio-note" id="audioNote" hidden></p>
    `;

    const toolbar = reader.querySelector(".reader-toolbar");

    if (toolbar) {
        toolbar.insertAdjacentElement("afterend", audioPanel);
    }

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
            display: inline-flex;
            align-items: center;
            gap: 6px;
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

        #voiceSelect {
            max-width: 230px;
            text-overflow: ellipsis;
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

        /* Page wrapper + reading highlight */
        .pdf-page-wrap {
            position: relative;
            max-width: 100%;
            line-height: 0;
        }

        .pdf-page-wrap canvas {
            cursor: pointer;
        }

        .tts-highlight-layer {
            position: absolute;
            inset: 0;
            overflow: hidden;
            pointer-events: none;
        }

        /* The PDF page is always white, so multiply keeps the text readable */
        .tts-line,
        .tts-word {
            position: absolute;
            mix-blend-mode: multiply;
            border-radius: 4px;
        }

        .tts-line {
            background: rgba(109, 141, 255, 0.20);
        }

        .tts-word {
            background: rgba(255, 213, 0, 0.60);
            box-shadow: 0 0 0 2px rgba(255, 213, 0, 0.35);
        }

        /* Keep the audio controls on screen while the page scrolls */
        .reader-audio-panel {
            position: sticky;
            top: 0;
            z-index: 30;
            margin: 10px 0;
            padding: 12px 18px;
        }

        .audio-controls input[type="checkbox"] {
            accent-color: var(--reader-primary);
        }

        @media (max-width: 700px) {
            .reader-audio-panel {
                position: static;
            }
        }
    `;

    document.head.appendChild(audioStyle);

    const audioPlay = document.getElementById("audioPlay");
    const audioPause = document.getElementById("audioPause");
    const audioStop = document.getElementById("audioStop");
    const speechRate = document.getElementById("speechRate");
    const voiceSelect = document.getElementById("voiceSelect");
    const highlightMode = document.getElementById("highlightMode");
    const autoScroll = document.getElementById("autoScroll");
    const audioStatus = document.getElementById("audioStatus");
    const audioNote = document.getElementById("audioNote");
    const audioBackward = document.getElementById("audioBackward");
    const audioForward = document.getElementById("audioForward");

    const STORE_VOICE = "readnext-tts-voice";
    const STORE_RATE = "readnext-tts-rate";
    const STORE_HIGHLIGHT = "readnext-tts-highlight";
    const STORE_SCROLL = "readnext-tts-autoscroll";

    function loadSetting(key) {
        try { return localStorage.getItem(key); } catch (_) { return null; }
    }

    function saveSetting(key, value) {
        try { localStorage.setItem(key, value); } catch (_) { /* ignore */ }
    }

    // Restore saved speed / highlight choices
    (function restoreSettings() {
        const rate = loadSetting(STORE_RATE);
        if (rate && [...speechRate.options].some(o => o.value === rate)) {
            speechRate.value = rate;
        }

        const mode = loadSetting(STORE_HIGHLIGHT);
        if (mode && [...highlightMode.options].some(o => o.value === mode)) {
            highlightMode.value = mode;
        }

        const scroll = loadSetting(STORE_SCROLL);
        if (scroll !== null) {
            autoScroll.checked = scroll === "1";
        }
    })();

    // Audio state
    let audioActive = false;
    let audioPaused = false;
    let audioPage = 1;
    let audioRunId = 0;

    let audioFullText = "";     // text of the page being read
    let audioChunks = [];       // [{start, end}] offsets into audioFullText
    let audioCharPosition = 0;  // where we are in audioFullText

    let pageText = null;        // {page, items, lines, text, currentLine}
    let textCache = null;       // text of a page that is shown but not being read
    let renderedPage = 0;       // page currently drawn on the canvas
    let lastHighlightPos = null;

    let autoScrollPausedUntil = 0; // auto-scroll stays off until this time
    let boundarySeen = false;
    let fallbackTimer = null;
    let estimateTimer = null;

    let voices = [];

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
        renderedPage = 0;
        updateControls();

        // The old highlight belongs to the old render; it is redrawn below.
        highlightLayer.textContent = "";

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
            currentViewport = pageViewport;

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

            renderedPage = requestedPage;

            loadingMessage.hidden = true;
            errorBox.hidden = true;

            zoomLevelLabel.textContent = `${Math.round(scale * 100)}%`;

            updateControls();
            scheduleProgressSave();

            // After zoom / resize, put the highlight back where it was.
            if (audioActive && lastHighlightPos !== null) {
                drawHighlight(lastHighlightPos, false);
            }

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

    // ---------------- VOICES ----------------

    function populateVoices() {
        if (!("speechSynthesis" in window)) return;

        voices = window.speechSynthesis.getVoices();
        if (!voices.length) return;

        const browserLang = (navigator.language || "en")
            .toLowerCase()
            .split("-")[0];

        const rank = voice => {
            const lang = (voice.lang || "").toLowerCase();
            if (lang.startsWith("en")) return 0;
            if (lang.startsWith(browserLang)) return 1;
            return 2;
        };

        const sorted = [...voices].sort((a, b) => {
            const byRank = rank(a) - rank(b);
            if (byRank) return byRank;

            if (a.localService !== b.localService) {
                return a.localService ? -1 : 1;
            }

            return a.name.localeCompare(b.name);
        });

        const wanted = voiceSelect.value || loadSetting(STORE_VOICE) || "";

        voiceSelect.innerHTML = "";

        sorted.forEach(voice => {
            const option = document.createElement("option");
            option.value = voice.voiceURI;
            option.textContent =
                `${voice.name} (${voice.lang})` +
                (voice.localService ? "" : " – online");
            voiceSelect.appendChild(option);
        });

        if (wanted && sorted.some(v => v.voiceURI === wanted)) {
            voiceSelect.value = wanted;
        } else {
            // Prefer a local English voice: those report word timing.
            const preferred =
                sorted.find(v => v.localService && /^en/i.test(v.lang)) ||
                sorted[0];
            voiceSelect.value = preferred.voiceURI;
        }
    }

    function getSelectedVoice() {
        const uri = voiceSelect.value;
        return voices.find(v => v.voiceURI === uri) || null;
    }

    if ("speechSynthesis" in window) {
        populateVoices();
        window.speechSynthesis.addEventListener("voiceschanged", populateVoices);
    }

    // ---------------- PAGE TEXT + GEOMETRY ----------------

    const measureCtx = document.createElement("canvas").getContext("2d");

    // Turn PDF.js text items into one string, remembering where each item
    // sits in that string and which visual line it belongs to.
    function buildPageText(textContent, pageNumber) {
        const styles = textContent.styles || {};
        const items = [];
        const lines = [];

        let text = "";
        let prev = null;
        let lineY = null;

        for (const raw of textContent.items) {
            if (typeof raw.str !== "string") continue;

            if (!raw.str.trim()) {
                if (prev && raw.hasEOL) prev.eol = true;
                continue;
            }

            const t = raw.transform;
            const fontSize = Math.hypot(t[2], t[3]) || 10;

            const newLine =
                lineY === null || Math.abs(t[5] - lineY) > fontSize * 0.5;

            if (newLine) {
                lines.push({ first: items.length, last: items.length });
                lineY = t[5];
            }

            let separator = "";

            if (prev) {
                const gap = t[4] - (prev.t[4] + prev.width);
                const needsSpace = newLine || prev.eol || gap > fontSize * 0.12;

                if (needsSpace && !/\s$/.test(text) && !/^\s/.test(raw.str)) {
                    separator = " ";
                }
            }

            const start = text.length + separator.length;
            text += separator + raw.str;

            const style = styles[raw.fontName];

            const item = {
                str: raw.str,
                t,
                width: raw.width,
                family: (style && style.fontFamily) || "sans-serif",
                eol: !!raw.hasEOL,
                start,
                end: text.length,
                line: lines.length - 1
            };

            items.push(item);
            lines[lines.length - 1].last = items.length - 1;
            prev = item;
        }

        return { page: pageNumber, items, lines, text, currentLine: -1 };
    }

    // Find the item that contains (or follows) a character offset.
    function findItem(pos) {
        const items = pageText.items;
        let lo = 0;
        let hi = items.length - 1;
        let found = -1;

        while (lo <= hi) {
            const mid = (lo + hi) >> 1;
            if (items[mid].start <= pos) {
                found = mid;
                lo = mid + 1;
            } else {
                hi = mid - 1;
            }
        }

        if (found >= 0 && pos >= items[found].end && found + 1 < items.length) {
            found++;
        }

        return found;
    }

    // How far (0..1) along an item a given character count sits,
    // measured with the item's own font so proportions are realistic.
    function textFraction(item, charCount, fontHeight) {
        const full = item.str;
        if (!full.length) return 0;

        measureCtx.font = `${Math.max(fontHeight, 1)}px ${item.family}`;

        const total = measureCtx.measureText(full).width;

        if (!total) return charCount / full.length;

        return measureCtx.measureText(full.slice(0, charCount)).width / total;
    }

    // Screen rectangle (in canvas CSS pixels) for part of one text item.
    function itemBox(item, from, to) {
        const t = pdfjsLib.Util.transform(currentViewport.transform, item.t);
        const fontHeight = Math.hypot(t[2], t[3]) || 10;
        const width = item.width * currentViewport.scale;

        const f0 = from <= 0 ? 0 : textFraction(item, from, fontHeight);
        const f1 = to >= item.str.length ? 1 : textFraction(item, to, fontHeight);

        return {
            left: t[4] + width * f0,
            top: t[5] - fontHeight * 0.88,
            width: Math.max(2, width * (f1 - f0)),
            height: fontHeight * 1.12
        };
    }

    function addRect(parent, className, box, ratio) {
        const el = document.createElement("div");
        el.className = className;
        el.style.left = `${box.left * ratio}px`;
        el.style.top = `${box.top * ratio}px`;
        el.style.width = `${box.width * ratio}px`;
        el.style.height = `${box.height * ratio}px`;
        parent.appendChild(el);
    }

    // Highlight the word at character offset `pos` (and its line).
    function drawHighlight(pos, allowScroll = true) {
        highlightLayer.textContent = "";
        lastHighlightPos = pos;

        const mode = highlightMode.value;

        if (
            mode === "off" ||
            !pageText ||
            pageText.page !== currentPage ||
            !currentViewport ||
            !pageText.items.length
        ) {
            return;
        }

        const text = pageText.text;
        if (!text.length) return;

        pos = Math.max(0, Math.min(pos, text.length - 1));

        // Move to the start of the word that contains pos.
        let wordStart = pos;
        while (wordStart < text.length && /\s/.test(text[wordStart])) wordStart++;
        while (wordStart > 0 && /\S/.test(text[wordStart - 1])) wordStart--;

        let wordEnd = wordStart;
        while (wordEnd < text.length && /\S/.test(text[wordEnd])) wordEnd++;

        if (wordEnd <= wordStart) return;

        const index = findItem(wordStart);
        if (index < 0) return;

        const items = pageText.items;
        const ratio = canvas.clientWidth / currentViewport.width;
        const fragment = document.createDocumentFragment();

        if (mode === "line" || mode === "both") {
            const lineIndex = items[index].line;
            const line = pageText.lines[lineIndex];

            let left = Infinity;
            let top = Infinity;
            let right = -Infinity;
            let bottom = -Infinity;

            for (let i = line.first; i <= line.last; i++) {
                const box = itemBox(items[i], 0, items[i].str.length);
                left = Math.min(left, box.left);
                top = Math.min(top, box.top);
                right = Math.max(right, box.left + box.width);
                bottom = Math.max(bottom, box.top + box.height);
            }

            addRect(fragment, "tts-line", {
                left: left - 4,
                top: top - 2,
                width: right - left + 8,
                height: bottom - top + 4
            }, ratio);
        }

        if (mode === "word" || mode === "both") {
            for (let i = index; i < items.length && items[i].start < wordEnd; i++) {
                const item = items[i];
                const from = Math.max(wordStart, item.start) - item.start;
                const to = Math.min(wordEnd, item.end) - item.start;

                if (to > from) {
                    addRect(fragment, "tts-word", itemBox(item, from, to), ratio);
                }
            }
        }

        highlightLayer.appendChild(fragment);

        // Keep the line being read on screen when the line changes.
        const lineIndex = items[index].line;

        if (allowScroll && pageText.currentLine !== lineIndex) {
            pageText.currentLine = lineIndex;
            maybeScrollTo(highlightLayer.firstElementChild);
        }
    }

    // ---------------- AUTO-SCROLL (gentle, and easy to override) ----------------

    function pauseAutoScroll(milliseconds) {
        autoScrollPausedUntil = Date.now() + milliseconds;
    }

    // Scroll only when the line leaves the visible area, and then move it to
    // the upper part of the screen so it doesn't need to scroll again for a
    // while. Never scrolls while the user is scrolling or using the controls.
    function maybeScrollTo(element) {
        if (!element || !autoScroll.checked) return;
        if (Date.now() < autoScrollPausedUntil) return;

        const rect = element.getBoundingClientRect();

        const panelIsSticky =
            window.getComputedStyle(audioPanel).position === "sticky";

        const topLimit =
            (panelIsSticky
                ? Math.max(0, audioPanel.getBoundingClientRect().bottom)
                : 0) + 12;

        const bottomLimit = window.innerHeight - 24;

        if (rect.top >= topLimit && rect.bottom <= bottomLimit) return;

        const targetTop = topLimit + (bottomLimit - topLimit) * 0.25;

        window.scrollBy({
            top: rect.top - targetTop,
            behavior: "smooth"
        });
    }

    // The user's own scrolling always wins.
    window.addEventListener("wheel", () => pauseAutoScroll(6000), { passive: true });
    window.addEventListener("touchmove", () => pauseAutoScroll(6000), { passive: true });

    window.addEventListener("keydown", event => {
        if (["ArrowUp", "ArrowDown", "PageUp", "PageDown", "Home", "End"].includes(event.key)) {
            pauseAutoScroll(6000);
        }
    });

    // Dragging the page scrollbar
    window.addEventListener("pointerdown", event => {
        if (event.target === document.documentElement) pauseAutoScroll(6000);
    });

    // Using the audio controls: leave the page alone for a while.
    audioPanel.addEventListener("pointerdown", () => pauseAutoScroll(10000));
    audioPanel.addEventListener("keydown", () => pauseAutoScroll(10000));
    audioPanel.addEventListener("change", () => pauseAutoScroll(10000));

    autoScroll.addEventListener("change", () => {
        saveSetting(STORE_SCROLL, autoScroll.checked ? "1" : "0");
    });

    function clearHighlight() {
        highlightLayer.textContent = "";
        lastHighlightPos = null;
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

    function clearTimers() {
        clearTimeout(fallbackTimer);
        clearInterval(estimateTimer);
        fallbackTimer = null;
        estimateTimer = null;
    }

    // Cancel speech safely, even when the engine is paused.
    function hardCancel() {
        window.speechSynthesis.cancel();
        window.speechSynthesis.resume();
    }

    // Split page text into speakable chunks. Offsets are exact positions in
    // `text`, which is what lets the highlight follow the voice.
    function buildChunks(text, maxLength = 800) {
        const pieces = [];
        const sentence = /[^.!?]+(?:[.!?]+["')\]]*|$)/g;
        let match;

        while ((match = sentence.exec(text)) !== null) {
            let start = match.index;
            const end = start + match[0].length;

            while (end - start > maxLength) {
                let cut = text.lastIndexOf(" ", start + maxLength);
                if (cut <= start) cut = start + maxLength;
                pieces.push([start, cut]);
                start = cut;
            }

            pieces.push([start, end]);
        }

        const chunks = [];
        let chunkStart = null;
        let chunkEnd = 0;

        pieces.forEach(([start, end]) => {
            if (chunkStart === null) {
                chunkStart = start;
                chunkEnd = end;
            } else if (end - chunkStart <= maxLength) {
                chunkEnd = end;
            } else {
                chunks.push({ start: chunkStart, end: chunkEnd });
                chunkStart = start;
                chunkEnd = end;
            }
        });

        if (chunkStart !== null) {
            chunks.push({ start: chunkStart, end: chunkEnd });
        }

        return chunks;
    }

    function stopAudio() {
        audioRunId++;
        clearTimers();
        hardCancel();

        audioActive = false;
        audioPaused = false;

        audioChunks = [];
        audioFullText = "";
        audioCharPosition = 0;
        pageText = null;

        clearHighlight();
        audioNote.hidden = true;

        updateAudioButtons();
        audioStatus.textContent = "Audio stopped";
    }

    // Some voices (mostly online ones) never report which word they are on.
    // For those, estimate the position from the speaking rate.
    function startEstimate(chunkStart, chunkEnd, runId, elapsedSeconds) {
        const charsPerSecond = 14 * (Number(speechRate.value) || 1);
        let estimate = chunkStart + charsPerSecond * elapsedSeconds;

        audioNote.textContent =
            "This voice doesn't report word timing, so the highlight is " +
            "approximate. Pick a voice without “online” in its name for " +
            "exact word-by-word highlighting.";
        audioNote.hidden = false;

        estimateTimer = setInterval(() => {
            if (runId !== audioRunId || boundarySeen) {
                clearInterval(estimateTimer);
                return;
            }

            if (audioPaused) return;

            estimate = Math.min(chunkEnd - 1, estimate + charsPerSecond * 0.12);
            audioCharPosition = Math.floor(estimate);
            drawHighlight(audioCharPosition);
        }, 120);
    }

    // Speak the page text starting at character offset `pos`.
    function speakFrom(pos, runId) {
        if (runId !== audioRunId || !audioActive) return;

        clearTimers();

        const chunkIndex = audioChunks.findIndex(chunk => pos < chunk.end);

        if (chunkIndex === -1) {
            advanceToNextPage(runId);
            return;
        }

        const chunk = audioChunks[chunkIndex];
        const start = Math.max(pos, chunk.start);
        const text = audioFullText.slice(start, chunk.end);

        if (!text.trim()) {
            speakFrom(chunk.end, runId);
            return;
        }

        audioCharPosition = start;
        boundarySeen = false;

        const utterance = new SpeechSynthesisUtterance(text);

        const voice = getSelectedVoice();
        if (voice) {
            utterance.voice = voice;
            utterance.lang = voice.lang;
        }

        utterance.rate = Number(speechRate.value) || 1;

        utterance.onstart = () => {
            if (runId !== audioRunId) return;
            drawHighlight(start);
        };

        utterance.onboundary = event => {
            if (runId !== audioRunId) return;
            if (event.name && event.name !== "word") return;

            boundarySeen = true;
            clearInterval(estimateTimer);
            audioNote.hidden = true;

            audioCharPosition = start + event.charIndex;
            drawHighlight(audioCharPosition);
        };

        utterance.onend = () => {
            if (runId !== audioRunId) return;
            clearTimers();
            speakFrom(chunk.end, runId);
        };

        utterance.onerror = event => {
            if (runId !== audioRunId) return;
            if (event.error === "interrupted" || event.error === "canceled") return;

            console.error("Speech error:", event);
            stopAudio();
            audioStatus.textContent = "Audio playback failed.";
        };

        window.speechSynthesis.speak(utterance);

        if (audioPaused) {
            window.speechSynthesis.pause();
        } else {
            audioStatus.textContent = `Playing page ${audioPage} of ${totalPages}`;
        }

        // If no word events arrive, fall back to an estimated highlight.
        fallbackTimer = setTimeout(() => {
            if (runId !== audioRunId || boundarySeen || !audioActive) return;
            startEstimate(start, chunk.end, runId, 1.5);
        }, 1500);
    }

    function advanceToNextPage(runId) {
        if (runId !== audioRunId || !audioActive) return;

        const nextPage = audioPage + 1;

        if (nextPage > totalPages) {
            audioActive = false;
            audioPaused = false;

            clearHighlight();
            audioNote.hidden = true;
            updateAudioButtons();

            audioStatus.textContent = "You have reached the end of the book.";

            scheduleProgressSave();
            return;
        }

        loadAudioPage(nextPage, runId);
    }

    // Show a page, extract its text and start reading it.
    async function loadAudioPage(pageNumber, runId, startPos = 0) {
        try {
            const page = await pdfDocument.getPage(pageNumber);
            const textContent = await page.getTextContent();

            if (runId !== audioRunId || !audioActive) return;

            audioPage = pageNumber;
            currentPage = pageNumber;

            pageText = null;
            lastHighlightPos = null;

            // Show the page that is about to be read (unless it already is).
            if (renderedPage !== pageNumber || isRendering) {
                await renderPage(pageNumber);
            } else {
                highlightLayer.textContent = "";
            }

            if (runId !== audioRunId || !audioActive) return;

            pageText = buildPageText(textContent, pageNumber);
            audioFullText = pageText.text;
            audioChunks = buildChunks(audioFullText);
            audioCharPosition = startPos;

            if (!audioFullText.trim()) {
                audioStatus.textContent =
                    `No readable text on page ${pageNumber}. Skipping...`;

                advanceToNextPage(runId);
                return;
            }

            speakFrom(startPos, runId);

        } catch (error) {
            console.error("Audio text extraction failed:", error);
            stopAudio();
            audioStatus.textContent = "Could not read this PDF page.";
        }
    }

    // Re-start speaking from the current position (used when the speed or
    // voice changes, and when skipping).
    function restartSpeech() {
        if (!audioActive || !audioFullText) return;

        const runId = ++audioRunId;

        clearTimers();
        hardCancel();

        speakFrom(audioCharPosition, runId);
    }

    function skipAudio(seconds) {
        if (!audioActive || !audioFullText) return;

        const charactersPerSecond = 15 * Number(speechRate.value);
        const movement = Math.round(seconds * charactersPerSecond);

        let target = Math.max(
            0,
            Math.min(audioFullText.length - 1, audioCharPosition + movement)
        );

        // Land on the start of a word.
        while (target > 0 && /\S/.test(audioFullText[target - 1])) target--;

        audioCharPosition = target;
        restartSpeech();
    }

    // Jump the audio to another page (Previous / Next / page box).
    async function jumpAudioToPage(targetPage) {
        const wasPaused = audioPaused;

        const runId = ++audioRunId;

        clearTimers();
        hardCancel();

        audioPage = targetPage;
        audioPaused = false;

        updateAudioButtons();

        await loadAudioPage(targetPage, runId);

        if (wasPaused && audioActive && runId === audioRunId) {
            audioPaused = true;
            window.speechSynthesis.pause();
            updateAudioButtons();
            audioStatus.textContent = "Audio paused";
        }
    }

    function startAudio(startPos = 0) {
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

        hardCancel();

        const runId = ++audioRunId;

        audioActive = true;
        audioPaused = false;

        audioPage = currentPage;
        audioChunks = [];

        updateAudioButtons();

        loadAudioPage(audioPage, runId, startPos);
    }

    audioPlay.addEventListener("click", () => startAudio());

    // ---------------- CLICK A LINE TO START READING THERE ----------------

    // Text of the page on screen, built the same way as for reading aloud
    // so character offsets match.
    async function textForPage(pageNumber) {
        if (pageText && pageText.page === pageNumber) return pageText;
        if (textCache && textCache.page === pageNumber) return textCache;

        const page = await pdfDocument.getPage(pageNumber);
        const textContent = await page.getTextContent();

        textCache = buildPageText(textContent, pageNumber);
        return textCache;
    }

    // Turn a click position into a character offset in the page text.
    // Returns -1 when the click is nowhere near any text.
    function offsetFromPoint(data, clientX, clientY) {
        const rect = canvas.getBoundingClientRect();
        const ratio = rect.width / currentViewport.width;

        const x = (clientX - rect.left) / ratio;
        const y = (clientY - rect.top) / ratio;

        let best = null;
        let bestScore = Infinity;

        for (const item of data.items) {
            const box = itemBox(item, 0, item.str.length);

            const dx = x < box.left
                ? box.left - x
                : x > box.left + box.width ? x - (box.left + box.width) : 0;

            const dy = y < box.top
                ? box.top - y
                : y > box.top + box.height ? y - (box.top + box.height) : 0;

            // Weigh vertical distance more so the right line wins.
            const score = dy * 4 + dx;

            if (score < bestScore) {
                bestScore = score;
                best = { item, box };
            }
        }

        if (!best || bestScore > 120) return -1;

        const { item, box } = best;
        const t = pdfjsLib.Util.transform(currentViewport.transform, item.t);
        const fontHeight = Math.hypot(t[2], t[3]) || 10;

        const fraction = Math.max(0, Math.min(1, (x - box.left) / box.width));

        // The character under the pointer.
        let charIndex = item.str.length - 1;

        for (let c = 0; c < item.str.length; c++) {
            const end = c + 1 >= item.str.length
                ? 1
                : textFraction(item, c + 1, fontHeight);

            if (end > fraction) {
                charIndex = c;
                break;
            }
        }

        return item.start + charIndex;
    }

    async function startReadingAt(clientX, clientY) {
        if (!pdfDocument || isRendering || !currentViewport) return;
        if (renderedPage !== currentPage) return;

        if (!("speechSynthesis" in window)) {
            audioStatus.textContent = "Your browser does not support Text-to-Speech.";
            return;
        }

        const pageAtClick = currentPage;

        let data;
        try {
            data = await textForPage(pageAtClick);
        } catch (error) {
            console.error("Could not read page text:", error);
            return;
        }

        // The page may have changed while the text was loading.
        if (pageAtClick !== currentPage || renderedPage !== currentPage) return;

        if (!data.items.length) {
            audioStatus.textContent =
                "This page has no selectable text, so it can't be read aloud.";
            return;
        }

        let pos = offsetFromPoint(data, clientX, clientY);
        if (pos < 0) return;

        // Start from the beginning of the clicked word.
        while (pos > 0 && /\S/.test(data.text[pos - 1])) pos--;

        if (audioActive) {
            // Still loading the page being read? Ignore the click.
            if (!pageText || pageText.page !== currentPage) return;

            audioPaused = false;
            audioCharPosition = pos;
            updateAudioButtons();
            restartSpeech();
        } else {
            startAudio(pos);
        }
    }

    canvas.title = "Click a line to start reading from there";

    canvas.addEventListener("click", event => {
        startReadingAt(event.clientX, event.clientY);
    });

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

    audioStop.addEventListener("click", stopAudio);

    audioBackward.addEventListener("click", () => skipAudio(-15));
    audioForward.addEventListener("click", () => skipAudio(15));

    // Changing speed or voice takes effect immediately, from the same word.
    speechRate.addEventListener("change", () => {
        saveSetting(STORE_RATE, speechRate.value);
        restartSpeech();
    });

    voiceSelect.addEventListener("change", () => {
        saveSetting(STORE_VOICE, voiceSelect.value);
        restartSpeech();
    });

    highlightMode.addEventListener("change", () => {
        saveSetting(STORE_HIGHLIGHT, highlightMode.value);

        if (audioActive && lastHighlightPos !== null) {
            drawHighlight(lastHighlightPos, false);
        } else {
            highlightLayer.textContent = "";
        }
    });

    updateAudioButtons();

    // -----------------------------------------------

    prevButton.addEventListener("click", () => {
        if (currentPage <= 1) return;

        if (audioActive) {
            jumpAudioToPage(currentPage - 1);
            return;
        }

        renderPage(currentPage - 1);
    });

    nextButton.addEventListener("click", () => {
        if (currentPage >= totalPages) return;

        if (audioActive) {
            jumpAudioToPage(currentPage + 1);
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
            await jumpAudioToPage(targetPage);
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
        try {
            window.speechSynthesis.cancel();
        } catch (_) { /* ignore */ }

        if (saveTimer) {
            clearTimeout(saveTimer);
            saveTimer = null;
            saveProgress();
        }
    });

    initializeReader();
});
