```html
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>PENGUIN: FROZEN FRENZY</title>
    <style>
        /* === CORE STYLES & RESET === */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            user-select: none;
            -webkit-user-select: none;
            touch-action: none;
            -webkit-touch-callout: none;
        }

        body, html {
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: #050b14;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            color: #f8fafc;
        }

        canvas {
            display: block;
            width: 100%;
            height: 100%;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 1;
        }

        /* === GLASSMORPHISM UI OVERLAYS === */
        .ui-layer {
            position: absolute;
            inset: 0;
            z-index: 10;
            pointer-events: none;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 12px;
        }

        .interactive {
            pointer-events: auto !important;
        }

        .glass-panel {
            background: rgba(15, 23, 42, 0.82);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(56, 189, 248, 0.25);
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.4);
        }

        /* === HUD TOP BAR === */
        .hud-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            width: 100%;
            gap: 8px;
        }

        .hud-card {
            padding: 8px 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .bar-container {
            width: 120px;
            height: 10px;
            background: rgba(15, 23, 42, 0.9);
            border-radius: 10px;
            overflow: hidden;
            position: relative;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .bar-delay {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            background: #ef4444;
            width: 100%;
            transition: width 0.4s ease-out;
        }

        .bar-fill {
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            background: linear-gradient(90deg, #10b981, #34d399);
            width: 100%;
            transition: width 0.15s ease-out;
        }

        .xp-bar-fill {
            background: linear-gradient(90deg, #f59e0b, #fbbf24);
        }

        .hud-title {
            text-align: center;
            font-size: 11px;
            font-weight: 800;
            letter-spacing: 1px;
            color: #38bdf8;
            text-transform: uppercase;
        }

        .hud-room {
            font-size: 15px;
            font-weight: 900;
            color: #ffffff;
        }

        .hud-type {
            font-size: 9px;
            font-weight: 800;
            color: #f59e0b;
            margin-top: 1px;
        }

        /* === BOSS HP BAR === */
        .boss-bar-container {
            position: absolute;
            top: 60px;
            left: 50%;
            transform: translateX(-50%);
            width: 90%;
            max-width: 420px;
            padding: 8px 14px;
            text-align: center;
            z-index: 15;
            transition: opacity 0.3s;
        }

        .boss-hp-track {
            width: 100%;
            height: 12px;
            background: #090d16;
            border-radius: 8px;
            overflow: hidden;
            position: relative;
            margin-top: 4px;
            border: 1px solid rgba(239, 68, 68, 0.4);
        }

        .boss-hp-fill {
            height: 100%;
            background: linear-gradient(90deg, #dc2626, #f59e0b);
            width: 100%;
            transition: width 0.15s linear;
        }

        /* === MOBILE CONTROLS === */
        .mobile-controls {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            width: 100%;
            padding-bottom: 4px;
        }

        .joystick-zone {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(56, 189, 248, 0.08);
            border: 2px solid rgba(56, 189, 248, 0.25);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .joystick-knob {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: rgba(56, 189, 248, 0.6);
            border: 2px solid #ffffff;
            box-shadow: 0 0 12px rgba(56, 189, 248, 0.5);
        }

        .action-btns {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-round {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 900;
            color: #fff;
            border: 2px solid rgba(56, 189, 248, 0.4);
            background: radial-gradient(circle, rgba(14, 165, 233, 0.6) 0%, rgba(3, 105, 161, 0.8) 100%);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            position: relative;
            overflow: hidden;
        }

        .btn-round:active {
            transform: scale(0.92);
        }

        .cd-overlay {
            position: absolute;
            inset: 0;
            background: rgba(15, 23, 42, 0.75);
            height: 100%;
            transition: height 0.05s linear;
        }

        /* === MODALS & OVERLAYS === */
        .modal-overlay {
            position: absolute;
            inset: 0;
            background: rgba(5, 11, 20, 0.88);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            z-index: 100;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 16px;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.25s ease;
        }

        .modal-overlay.active {
            opacity: 1;
            pointer-events: auto;
        }

        .modal-card {
            width: 100%;
            max-width: 420px;
            padding: 24px;
            text-align: center;
            position: relative;
        }

        .btn-ui {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            font-size: 15px;
            font-weight: 800;
            border-radius: 12px;
            border: 1px solid rgba(56, 189, 248, 0.4);
            background: linear-gradient(135deg, #0284c7, #0369a1);
            color: #ffffff;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(2, 132, 199, 0.35);
            transition: transform 0.12s, filter 0.12s;
        }

        .btn-ui:hover {
            filter: brightness(1.1);
        }

        .btn-ui:active {
            transform: scale(0.96);
        }

        .btn-secondary {
            background: rgba(30, 41, 59, 0.8);
            border-color: rgba(148, 163, 184, 0.3);
            color: #cbd5e1;
            box-shadow: none;
        }

        .btn-danger {
            background: linear-gradient(135deg, #dc2626, #991b1b);
            border-color: rgba(248, 113, 113, 0.4);
            box-shadow: 0 4px 14px rgba(220, 38, 38, 0.35);
        }

        .upgrade-grid {
            display: grid;
            grid-template-cols: 1fr;
            gap: 10px;
            margin-top: 16px;
            width: 100%;
        }

        .upgrade-card {
            padding: 14px;
            border-radius: 12px;
            text-align: left;
            cursor: pointer;
            border: 2px solid rgba(56, 189, 248, 0.3);
            background: rgba(15, 23, 42, 0.9);
            transition: transform 0.15s, border-color 0.15s;
        }

        .upgrade-card:hover {
            transform: translateY(-2px);
            border-color: #38bdf8;
        }

        /* === AREA ANNOUNCEMENT BANNER === */
        .area-banner {
            position: absolute;
            top: 30%;
            left: 50%;
            transform: translate(-50%, -50%) scale(0.8);
            z-index: 50;
            pointer-events: none;
            text-align: center;
            opacity: 0;
            transition: opacity 0.5s ease, transform 0.5s ease;
        }

        .area-banner.show {
            opacity: 1;
            transform: translate(-50%, -50%) scale(1);
        }

        .area-banner-title {
            font-size: 28px;
            font-weight: 900;
            color: #38bdf8;
            text-shadow: 0 0 20px rgba(56, 189, 248, 0.8);
            text-transform: uppercase;
            letter-spacing: 2px;
        }

        /* === TUTORIAL OVERLAY === */
        .tutorial-box {
            position: absolute;
            bottom: 140px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.85);
            padding: 8px 16px;
            border-radius: 20px;
            border: 1px solid rgba(56, 189, 248, 0.4);
            font-size: 12px;
            color: #e2e8f0;
            pointer-events: none;
            z-index: 20;
            transition: opacity 0.5s;
        }

        /* === FOOTER IDENTITAS === */
        .student-footer {
            margin-top: 16px;
            font-size: 11px;
            color: #94a3b8;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 10px;
            font-weight: 600;
        }

        /* Toast Message */
        .toast {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.95);
            border: 1px solid #f59e0b;
            color: #fbbf24;
            padding: 8px 18px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            z-index: 200;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s;
        }

        .toast.show {
            opacity: 1;
        }
    </style>
</head>
<body>

    <!-- GAME CANVAS -->
    <canvas id="gameCanvas"></canvas>

    <!-- UI HUD OVERLAY LAYER -->
    <div id="ui-layer" class="ui-layer">
        
        <!-- HUD TOP BAR -->
        <div class="hud-top">
            <!-- PLAYER PROFILE -->
            <div class="glass-panel hud-card interactive">
                <span style="font-size: 24px;">🐧</span>
                <div>
                    <div style="display: flex; justify-content: space-between; font-size: 11px; font-weight: 800; color: #bae6fd;">
                        <span>MR. KARO</span>
                        <span id="hud-level" style="color: #fbbf24;">LV. 1</span>
                    </div>
                    <!-- HP BAR -->
                    <div class="bar-container" style="margin-top: 3px;">
                        <div id="hp-bar-delay" class="bar-delay"></div>
                        <div id="hp-bar-fill" class="bar-fill"></div>
                    </div>
                    <div style="font-size: 9px; font-family: monospace; color: #cbd5e1; margin-top: 2px;" id="hp-text">100 / 100</div>
                    <!-- XP BAR -->
                    <div class="bar-container" style="height: 4px; margin-top: 3px;">
                        <div id="xp-bar-fill" class="bar-fill xp-bar-fill" style="width: 0%;"></div>
                    </div>
                </div>
            </div>

            <!-- ROOM & AREA INFO -->
            <div class="glass-panel hud-card interactive" style="flex-direction: column; padding: 6px 14px;">
                <div id="hud-area-title" class="hud-title">SNOWY SHORE</div>
                <div id="hud-room-text" class="hud-room">ROOM 1 / 5</div>
                <div id="hud-room-type" class="hud-type">NORMAL ROOM</div>
            </div>

            <!-- CURRENCY & QUICK ACTIONS -->
            <div style="display: flex; gap: 6px;" class="interactive">
                <div class="glass-panel hud-card" style="font-weight: 900; color: #fbbf24; font-size: 14px;">
                    <span>🐟</span> <span id="hud-coins">0</span>
                </div>
                <button id="btn-audio" class="glass-panel hud-card" style="cursor: pointer; font-size: 16px;">🔊</button>
                <button id="btn-pause" class="glass-panel hud-card" style="cursor: pointer; font-size: 16px;">⏸️</button>
            </div>
        </div>

        <!-- BOSS HP OVERLAY -->
        <div id="boss-hud" class="glass-panel boss-bar-container" style="display: none;">
            <div style="display: flex; justify-content: space-between; font-size: 11px; font-weight: 900;">
                <span id="boss-name" style="color: #ef4444; letter-spacing: 1px;">FROSTFANG</span>
                <span id="boss-phase" style="color: #38bdf8;">PHASE 1</span>
            </div>
            <div class="boss-hp-track">
                <div id="boss-hp-delay" class="bar-delay"></div>
                <div id="boss-hp-fill" class="boss-hp-fill"></div>
            </div>
        </div>

        <!-- AREA BANNER POPUP -->
        <div id="area-banner" class="area-banner">
            <div id="area-banner-text" class="area-banner-title">AREA 1: SNOWY SHORE</div>
        </div>

        <!-- TUTORIAL TIP BOX -->
        <div id="tutorial-box" class="tutorial-box" style="display: none;">
            💡 WASD / Joystick untuk bergerak | Spasi / Tombol Kanan untuk Serang & Dash
        </div>

        <!-- MOBILE CONTROLS LAYER -->
        <div class="mobile-controls">
            <!-- VIRTUAL JOYSTICK -->
            <div id="joystick-zone" class="joystick-zone interactive">
                <div id="joystick-knob" class="joystick-knob"></div>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="action-btns interactive">
                <button id="btn-attack" class="btn-round" style="background: radial-gradient(circle, #0284c7 0%, #0369a1 100%);">
                    <span>🐟</span>
                    <span style="font-size: 8px; font-weight: 700; margin-top: -2px;">SERANG</span>
                </button>
                <button id="btn-dash" class="btn-round">
                    <div id="dash-cd-overlay" class="cd-overlay" style="height: 0%;"></div>
                    <span style="z-index: 2;">💨</span>
                    <span style="font-size: 8px; font-weight: 700; margin-top: -2px; z-index: 2;">DASH</span>
                </button>
            </div>
        </div>
    </div>

    <!-- === MODALS LAYER === -->

    <!-- MAIN MENU MODAL -->
    <div id="modal-main-menu" class="modal-overlay active">
        <div class="glass-panel modal-card">
            <div style="font-size: 50px; margin-bottom: 4px;">🐧</div>
            <h1 style="font-size: 26px; font-weight: 900; color: #38bdf8; letter-spacing: 2px;">PENGUIN</h1>
            <h2 style="font-size: 16px; font-weight: 800; color: #e2e8f0; letter-spacing: 4px; margin-bottom: 16px;">FROZEN FRENZY</h2>

            <button id="btn-start" class="btn-ui">PLAY NOW 🚀</button>
            <button id="btn-select-area" class="btn-ui btn-secondary">PILIH AREA 🗺️</button>
            <button id="btn-open-shop" class="btn-ui btn-secondary">PERMANENT SHOP 🛒</button>
            <button id="btn-how-to" class="btn-ui btn-secondary">CARA BERMAIN 📜</button>

            <!-- STUDENT IDENTIFIER FOOTER -->
            <div class="student-footer">
                Tugas Game Dev | <span id="student-info-text">Nama: Rafka Rizan Ramadhan | Kelas: XI.E</span>
            </div>
        </div>
    </div>

    <!-- HOW TO PLAY MODAL -->
    <div id="modal-how-to" class="modal-overlay">
        <div class="glass-panel modal-card" style="max-width: 480px; text-align: left;">
            <h3 style="font-size: 18px; font-weight: 900; color: #38bdf8; text-align: center; margin-bottom: 12px;">CARA BERMAIN</h3>
            <div style="font-size: 12px; line-height: 1.6; color: #cbd5e1; space-y: 8px;">
                <p>🔹 <strong>Kontrol Desktop:</strong> Gunakan WASD/Panah untuk bergerak, Klik Mouse/Spasi untuk serang, Shift untuk Dash, P/Esc untuk Pause.</p>
                <p>🔹 <strong>Kontrol HP:</strong> Gunakan Joystick kiri untuk bergerak, Tombol Kanan untuk Serang & Dash.</p>
                <p>🔹 <strong>Tujuan:</strong> Kalahkan seluruh musuh di setiap room untuk mendapatkan XP, Koin Ikan 🐟, dan Upgrade Kemampuan.</p>
                <p>🔹 <strong>Boss:</strong> Setiap Room 5 terdapat Boss Area! Perhatikan indikator lingkaran/garis merah sebelum Boss menyerang!</p>
            </div>
            <button id="btn-close-how" class="btn-ui btn-secondary" style="margin-top: 16px;">KEMBALI</button>
        </div>
    </div>

    <!-- AREA SELECT MODAL -->
    <div id="modal-area" class="modal-overlay">
        <div class="glass-panel modal-card" style="max-width: 440px;">
            <h3 style="font-size: 18px; font-weight: 900; color: #38bdf8; margin-bottom: 14px;">PILIH AREA PETUALANGAN</h3>
            <div id="area-list" style="display: flex; flex-direction: column; gap: 10px; max-height: 280px; overflow-y: auto;"></div>
            <button id="btn-close-area" class="btn-ui btn-secondary" style="margin-top: 14px;">KEMBALI</button>
        </div>
    </div>

    <!-- PERMANENT SHOP MODAL -->
    <div id="modal-shop" class="modal-overlay">
        <div class="glass-panel modal-card" style="max-width: 460px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                <h3 style="font-size: 18px; font-weight: 900; color: #f59e0b;">PERMANENT SHOP</h3>
                <div style="font-size: 14px; font-weight: 900; color: #fbbf24;">🐟 <span id="shop-coins">0</span></div>
            </div>
            <div id="shop-list" style="display: flex; flex-direction: column; gap: 8px; max-height: 280px; overflow-y: auto;"></div>
            <div style="display: flex; gap: 8px; margin-top: 14px;">
                <button id="btn-reset-data" class="btn-ui btn-danger" style="flex: 1; padding: 10px; font-size: 12px;">RESET DATA ⚠️</button>
                <button id="btn-close-shop" class="btn-ui btn-secondary" style="flex: 2; padding: 10px; font-size: 13px;">KEMBALI</button>
            </div>
        </div>
    </div>

    <!-- PAUSE MODAL -->
    <div id="modal-pause" class="modal-overlay">
        <div class="glass-panel modal-card">
            <div style="font-size: 40px; margin-bottom: 4px;">⏸️</div>
            <h3 style="font-size: 20px; font-weight: 900; color: #38bdf8; margin-bottom: 14px;">GAME DIJEDA</h3>
            <button id="btn-resume" class="btn-ui">▶️ LANJUTKAN</button>
            <button id="btn-restart-run" class="btn-ui btn-secondary">🔄 ULANGI RUN</button>
            <button id="btn-quit-main" class="btn-ui btn-danger">🏠 MENU UTAMA</button>
        </div>
    </div>

    <!-- LEVEL UP / UPGRADE MODAL -->
    <div id="modal-upgrade" class="modal-overlay">
        <div class="glass-panel modal-card" style="max-width: 440px;">
            <div style="font-size: 12px; font-weight: 800; color: #f59e0b; letter-spacing: 2px;">LEVEL UP!</div>
            <h3 style="font-size: 20px; font-weight: 900; color: #ffffff; margin-bottom: 6px;">PILIH KEMAMPUAN</h3>
            <div id="upgrade-cards" class="upgrade-grid"></div>
        </div>
    </div>

    <!-- ROOM CLEAR MODAL -->
    <div id="modal-room-clear" class="modal-overlay">
        <div class="glass-panel modal-card">
            <div style="font-size: 44px; margin-bottom: 4px;">🧊</div>
            <h3 style="font-size: 20px; font-weight: 900; color: #34d399; margin-bottom: 10px;">ROOM BERSIH!</h3>
            <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 16px; font-size: 13px; font-weight: 700;">
                <div class="glass-panel" style="padding: 8px; color: #34d399;" id="rc-heal">+0 HP</div>
                <div class="glass-panel" style="padding: 8px; color: #fbbf24;" id="rc-coins">🐟 +0 KOIN</div>
                <div class="glass-panel" style="padding: 8px; color: #38bdf8;" id="rc-xp">+0 XP</div>
            </div>
            <button id="btn-next-room" class="btn-ui">LANJUT ROOM ➔</button>
        </div>
    </div>

    <!-- GAME OVER MODAL -->
    <div id="modal-game-over" class="modal-overlay">
        <div class="glass-panel modal-card">
            <div style="font-size: 44px; margin-bottom: 4px;">💔</div>
            <h3 style="font-size: 22px; font-weight: 900; color: #ef4444; margin-bottom: 6px;">GAME OVER</h3>
            <p style="font-size: 11px; color: #94a3b8; margin-bottom: 14px;">Mr. Karo kehabisan tenaga...</p>
            <div style="text-align: left; font-size: 12px; line-height: 1.8; color: #cbd5e1; margin-bottom: 16px;" class="glass-panel" style="padding: 12px;">
                <div>Area Reached: <strong id="go-area" style="color: #38bdf8;">1</strong></div>
                <div>Room Reached: <strong id="go-room" style="color: #38bdf8;">1</strong></div>
                <div>Koin Ditemukan: <strong id="go-coins" style="color: #fbbf24;">0</strong></div>
                <div>Musuh Dikalahkan: <strong id="go-kills" style="color: #f43f5e;">0</strong></div>
                <div>Waktu Bermain: <strong id="go-time" style="color: #a7f3d0;">00:00</strong></div>
            </div>
            <button id="btn-retry" class="btn-ui">COBA LAGI 🔄</button>
            <button id="btn-go-main" class="btn-ui btn-secondary">MENU UTAMA 🏠</button>
        </div>
    </div>

    <!-- VICTORY MODAL -->
    <div id="modal-victory" class="modal-overlay">
        <div class="glass-panel modal-card">
            <div style="font-size: 50px; margin-bottom: 4px;">👑</div>
            <h3 style="font-size: 22px; font-weight: 900; color: #f59e0b; margin-bottom: 6px;">KEMENANGAN MUTLAK!</h3>
            <p style="font-size: 12px; color: #e2e8f0; margin-bottom: 16px;">Mr. Karo berhasil menguasai seluruh Kutub Selatan!</p>
            <button id="btn-vic-main" class="btn-ui">MENU UTAMA 🏠</button>
        </div>
    </div>

    <!-- TOAST NOTIFICATION -->
    <div id="toast" class="toast">Notifikasi</div>

    <!-- === GAME ENGINE SCRIPT === -->
    <script>
        /* === A. CONFIGURATION & BALANCE SETTINGS === */
        const STUDENT_INFO = {
            name: "Rafka Rizan Ramadhan",
            class: "XI.E"
        };

        const CONFIG = {
            GAME_VERSION: 5,
            SAVE_KEY: "PENGUIN_FROZEN_FRENZY_V5",
            CANVAS: { width: 960, height: 540 },
            CAMERA_SHAKE_DECAY: 15,
            PLAYER: {
                baseHp: 100,
                baseDamage: 25,
                baseSpeed: 3.4,
                baseAttackCd: 0.5,
                dashCd: 2.0,
                dashDuration: 0.22,
                dashSpeedMult: 2.8,
                iFrameDuration: 0.8,
                pickupRadius: 75
            },
            AREAS: {
                1: { name: "Snowy Shore", bg: "#091322", floor: "#152338", ice: "#38bdf8", boss: "FROSTFANG" },
                2: { name: "Ice Cave", bg: "#08131e", floor: "#0f2d4a", ice: "#0284c7", boss: "GLACIER CRUSHER" },
                3: { name: "Blizzard Peak", bg: "#0c1a2b", floor: "#1a365d", ice: "#60a5fa", boss: "ARCTIC ALPHA" },
                4: { name: "Frozen Palace", bg: "#160f29", floor: "#2d1b4e", ice: "#c084fc", boss: "FROST KING" }
            },
            ENEMIES: {
                CHASER: { name: "Arctic Fox", hp: 40, speed: 2.2, size: 16, xp: 10, color: "#f97316" },
                RANGED: { name: "Snow Owl", hp: 50, speed: 1.5, size: 15, xp: 15, color: "#e2e8f0" },
                CHARGER: { name: "Arctic Wolf", hp: 85, speed: 1.9, size: 18, xp: 20, color: "#cbd5e1" },
                HEAVY: { name: "Polar Bear", hp: 200, speed: 1.1, size: 28, xp: 40, color: "#f8fafc" }
            },
            UPGRADES: [
                { id: "dmg", name: "Serangan+", desc: "+25% Damage Ikan", maxLvl: 5 },
                { id: "spd", name: "Kecepatan+", desc: "+15% Kecepatan Jalan", maxLvl: 5 },
                { id: "hp", name: "Max HP+", desc: "+25 Max HP & Heal", maxLvl: 5 },
                { id: "dash", name: "Quick Dash", desc: "-20% Cooldown Dash", maxLvl: 3 },
                { id: "twin", name: "Twin Salmon", desc: "+1 Proyeksil Ikan", maxLvl: 3 },
                { id: "regrow", name: "Pemulihan", desc: "Heal 10% HP tiap Room", maxLvl: 3 },
                { id: "magnet", name: "Magnet Ikan", desc: "+50% Jangkauan Magnet", maxLvl: 3 },
                { id: "pierce", name: "Menembus", desc: "Ikan Menembus +1 Musuh", maxLvl: 3 }
            ],
            SHOP: [
                { id: "hp", name: "Base Max HP", desc: "+15 HP Maksimal", baseCost: 50, costMult: 1.6, maxLvl: 5 },
                { id: "dmg", name: "Base Damage", desc: "+5 Damage Ikan", baseCost: 60, costMult: 1.6, maxLvl: 5 },
                { id: "spd", name: "Move Speed", desc: "+0.2 Kecepatan", baseCost: 40, costMult: 1.5, maxLvl: 5 },
                { id: "dash", name: "Dash Efficiency", desc: "-0.2s Dash CD", baseCost: 75, costMult: 1.8, maxLvl: 3 },
                { id: "coinMult", name: "Bonus Koin", desc: "+20% Koin Ditemukan", baseCost: 80, costMult: 1.7, maxLvl: 5 },
                { id: "xpMult", name: "Bonus XP", desc: "+20% Perolehan XP", baseCost: 80, costMult: 1.7, maxLvl: 5 }
            ]
        };

        /* === B. AUDIO ENGINE (WEB AUDIO SYNTHESIS) === */
        const AudioEngine = {
            ctx: null,
            muted: false,
            init() {
                if (!this.ctx) {
                    const AudioCtx = window.AudioContext || window.webkitAudioContext;
                    if (AudioCtx) this.ctx = new AudioCtx();
                }
                if (this.ctx && this.ctx.state === 'suspended') {
                    this.ctx.resume();
                }
            },
            playTone(freq, duration, type = 'sine', vol = 0.12) {
                if (this.muted) return;
                this.init();
                if (!this.ctx) return;
                try {
                    const osc = this.ctx.createOscillator();
                    const gain = this.ctx.createGain();
                    osc.type = type;
                    osc.frequency.setValueAtTime(freq, this.ctx.currentTime);
                    gain.gain.setValueAtTime(vol, this.ctx.currentTime);
                    gain.gain.exponentialRampToValueAtTime(0.0001, this.ctx.currentTime + duration);
                    osc.connect(gain);
                    gain.connect(this.ctx.destination);
                    osc.start();
                    osc.stop(this.ctx.currentTime + duration);
                } catch (e) {}
            },
            playThrow() { this.playTone(420, 0.08, 'sine', 0.08); },
            playHit() { this.playTone(160, 0.1, 'triangle', 0.15); },
            playCrit() { this.playTone(620, 0.15, 'square', 0.12); },
            playKill() { this.playTone(220, 0.18, 'sawtooth', 0.1); },
            playDash() { this.playTone(320, 0.12, 'sine', 0.12); },
            playCoin() { this.playTone(880, 0.08, 'sine', 0.1); },
            playLevelUp() {
                this.playTone(320, 0.1, 'sine', 0.1);
                setTimeout(() => this.playTone(480, 0.1, 'sine', 0.1), 80);
                setTimeout(() => this.playTone(640, 0.2, 'sine', 0.12), 160);
            },
            playBossWarning() { this.playTone(110, 0.4, 'sawtooth', 0.25); },
            playClick() { this.playTone(500, 0.04, 'sine', 0.05); }
        };

        /* === C. LOCALSTORAGE SAVE SYSTEM === */
        const SaveSystem = {
            data: {
                version: CONFIG.GAME_VERSION,
                coins: 0,
                unlockedArea: 1,
                records: { maxArea: 1, maxRoom: 1, totalCoins: 0 },
                upgrades: { hp: 0, dmg: 0, spd: 0, dash: 0, coinMult: 0, xpMult: 0 },
                muted: false
            },
            load() {
                try {
                    const raw = localStorage.getItem(CONFIG.SAVE_KEY);
                    if (raw) {
                        const parsed = JSON.parse(raw);
                        if (parsed && parsed.version === CONFIG.GAME_VERSION) {
                            this.data = { ...this.data, ...parsed };
                        }
                    }
                } catch (e) {
                    console.warn("Storage access warning", e);
                }
                AudioEngine.muted = !!this.data.muted;
            },
            save() {
                try {
                    this.data.muted = AudioEngine.muted;
                    localStorage.setItem(CONFIG.SAVE_KEY, JSON.stringify(this.data));
                } catch (e) {}
            },
            reset() {
                try { localStorage.removeItem(CONFIG.SAVE_KEY); } catch (e) {}
                this.data = {
                    version: CONFIG.GAME_VERSION,
                    coins: 0,
                    unlockedArea: 1,
                    records: { maxArea: 1, maxRoom: 1, totalCoins: 0 },
                    upgrades: { hp: 0, dmg: 0, spd: 0, dash: 0, coinMult: 0, xpMult: 0 },
                    muted: false
                };
                this.save();
            }
        };

        SaveSystem.load();

        /* === D. INPUT SYSTEM === */
        const Input = {
            keys: {},
            joystick: { active: false, x: 0, y: 0, touchId: null },
            btnAttack: false,
            btnDash: false,
            init() {
                window.addEventListener('keydown', (e) => {
                    if (['Space', 'ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'KeyW', 'KeyS', 'KeyA', 'KeyD'].includes(e.code)) {
                        e.preventDefault();
                    }
                    this.keys[e.code] = true;

                    if (e.code === 'KeyP' || e.code === 'Escape') {
                        if (State.isRunning && !State.isPaused) State.pause();
                        else if (State.isPaused) State.resume();
                    }
                    if (e.code === 'ShiftLeft' || e.code === 'ShiftRight') {
                        if (State.player) State.player.triggerDash();
                    }
                });

                window.addEventListener('keyup', (e) => {
                    this.keys[e.code] = false;
                });

                window.addEventListener('blur', () => this.reset());

                // Touch Controls Setup
                const zone = document.getElementById('joystick-zone');
                const knob = document.getElementById('joystick-knob');

                zone.addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    const touch = e.changedTouches[0];
                    this.joystick.active = true;
                    this.joystick.touchId = touch.identifier;
                    this.updateJoystick(touch, zone, knob);
                }, { passive: false });

                window.addEventListener('touchmove', (e) => {
                    if (!this.joystick.active) return;
                    for (let i = 0; i < e.changedTouches.length; i++) {
                        if (e.changedTouches[i].identifier === this.joystick.touchId) {
                            this.updateJoystick(e.changedTouches[i], zone, knob);
                            break;
                        }
                    }
                }, { passive: false });

                const endTouch = (e) => {
                    for (let i = 0; i < e.changedTouches.length; i++) {
                        if (e.changedTouches[i].identifier === this.joystick.touchId) {
                            this.joystick.active = false;
                            this.joystick.x = 0;
                            this.joystick.y = 0;
                            this.joystick.touchId = null;
                            knob.style.transform = `translate(0px, 0px)`;
                            break;
                        }
                    }
                };

                window.addEventListener('touchend', endTouch);
                window.addEventListener('touchcancel', endTouch);

                // Touch Action Buttons
                document.getElementById('btn-attack').addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    this.btnAttack = true;
                });
                document.getElementById('btn-attack').addEventListener('touchend', (e) => {
                    e.preventDefault();
                    this.btnAttack = false;
                });

                document.getElementById('btn-dash').addEventListener('touchstart', (e) => {
                    e.preventDefault();
                    if (State.player) State.player.triggerDash();
                });
            },
            updateJoystick(touch, zone, knob) {
                const rect = zone.getBoundingClientRect();
                const cx = rect.left + rect.width / 2;
                const cy = rect.top + rect.height / 2;
                let dx = touch.clientX - cx;
                let dy = touch.clientY - cy;
                const maxR = rect.width / 2;
                const dist = Math.hypot(dx, dy);

                if (dist > maxR) {
                    dx = (dx / dist) * maxR;
                    dy = (dy / dist) * maxR;
                }

                knob.style.transform = `translate(${dx}px, ${dy}px)`;
                this.joystick.x = dx / maxR;
                this.joystick.y = dy / maxR;
            },
            reset() {
                this.keys = {};
                this.joystick.active = false;
                this.joystick.x = 0;
                this.joystick.y = 0;
                this.btnAttack = false;
                this.btnDash = false;
                const knob = document.getElementById('joystick-knob');
                if (knob) knob.style.transform = `translate(0px, 0px)`;
            }
        };

        /* === E. OBJECT POOLING FOR PARTICLES === */
        const ParticlePool = {
            pool: [],
            active: [],
            max: 180,
            spawn(x, y, vx, vy, color, size, life, type = 'default', text = '') {
                let p = this.pool.pop() || {};
                p.x = x; p.y = y; p.vx = vx; p.vy = vy;
                p.color = color; p.size = size; p.life = life; p.maxLife = life;
                p.type = type; p.text = text;
                this.active.push(p);
                return p;
            },
            updateAndDraw(ctx, dt) {
                for (let i = this.active.length - 1; i >= 0; i--) {
                    let p = this.active[i];
                    p.x += p.vx * dt * 60;
                    p.y += p.vy * dt * 60;
                    p.life -= dt;

                    if (p.life <= 0) {
                        this.active.splice(i, 1);
                        if (this.pool.length < this.max) this.pool.push(p);
                        continue;
                    }

                    const alpha = Math.max(0, p.life / p.maxLife);
                    ctx.save();
                    ctx.globalAlpha = alpha;

                    if (p.type === 'text') {
                        ctx.font = '900 14px sans-serif';
                        ctx.fillStyle = p.color;
                        ctx.textAlign = 'center';
                        ctx.fillText(p.text, p.x, p.y);
                    } else {
                        ctx.fillStyle = p.color;
                        ctx.beginPath();
                        ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                        ctx.fill();
                    }
                    ctx.restore();
                }
            },
            clear() {
                this.pool.push(...this.active);
                this.active = [];
            }
        };

        /* === F. GAME ENTITIES === */
        class Player {
            constructor() {
                const u = SaveSystem.data.upgrades;
                this.maxHp = CONFIG.PLAYER.baseHp + u.hp * 15;
                this.hp = this.maxHp;
                this.speed = CONFIG.PLAYER.baseSpeed + u.spd * 0.2;
                this.damage = CONFIG.PLAYER.baseDamage + u.dmg * 5;
                this.attackCd = Math.max(0.2, CONFIG.PLAYER.baseAttackCd);
                this.dashCd = Math.max(0.8, CONFIG.PLAYER.dashCd - u.dash * 0.2);

                this.x = CONFIG.CANVAS.width / 2;
                this.y = CONFIG.CANVAS.height / 2;
                this.radius = 16;
                this.level = 1;
                this.xp = 0;
                this.xpNeeded = 35;

                this.attackTimer = 0;
                this.dashTimer = 0;
                this.isDashing = false;
                this.dashTimeLeft = 0;
                this.iFrameTimer = 0;

                this.upgrades = { dmg: 0, spd: 0, hp: 0, dash: 0, twin: 0, regrow: 0, magnet: 0, pierce: 0 };
                this.waddle = 0;
            }

            triggerDash() {
                if (this.dashTimer > 0 || this.isDashing) return;
                this.isDashing = true;
                this.dashTimeLeft = CONFIG.PLAYER.dashDuration;
                this.dashTimer = this.dashCd;
                this.iFrameTimer = CONFIG.PLAYER.dashDuration + 0.1;
                AudioEngine.playDash();
                Renderer.addCameraShake(3);

                for (let i = 0; i < 10; i++) {
                    ParticlePool.spawn(this.x, this.y, (Math.random() - 0.5) * 3, (Math.random() - 0.5) * 3, '#bae6fd', 4, 0.3);
                }
            }

            update(dt) {
                // Invulnerability & Timers
                if (this.iFrameTimer > 0) this.iFrameTimer -= dt;
                if (this.dashTimer > 0) this.dashTimer -= dt;

                // Movement Logic
                let mx = 0, my = 0;
                if (Input.keys['KeyW'] || Input.keys['ArrowUp']) my -= 1;
                if (Input.keys['KeyS'] || Input.keys['ArrowDown']) my += 1;
                if (Input.keys['KeyA'] || Input.keys['ArrowLeft']) mx -= 1;
                if (Input.keys['KeyD'] || Input.keys['ArrowRight']) mx += 1;

                if (Input.joystick.active) {
                    mx = Input.joystick.x;
                    my = Input.joystick.y;
                }

                const len = Math.hypot(mx, my);
                if (len > 0) {
                    const normX = mx / (len > 1 ? len : 1);
                    const normY = my / (len > 1 ? len : 1);
                    const spd = (this.isDashing ? this.speed * CONFIG.PLAYER.dashSpeedMult : this.speed);
                    
                    this.x += normX * spd * dt * 60;
                    this.y += normY * spd * dt * 60;
                    this.waddle += dt * 12;
                } else {
                    if (this.isDashing) {
                        this.x += this.speed * CONFIG.PLAYER.dashSpeedMult * dt * 60;
                    }
                }

                if (this.isDashing) {
                    this.dashTimeLeft -= dt;
                    if (this.dashTimeLeft <= 0) this.isDashing = false;
                }

                // Bounds Locking
                this.x = Math.max(30, Math.min(CONFIG.CANVAS.width - 30, this.x));
                this.y = Math.max(30, Math.min(CONFIG.CANVAS.height - 30, this.y));

                // Auto Attack / Manual Attack
                this.attackTimer -= dt;
                if ((this.attackTimer <= 0) && (len > 0 || Input.btnAttack || Input.keys['Space'])) {
                    this.autoAttack();
                    this.attackTimer = this.attackCd;
                }

                // Pickup Magnet Effect
                const magnetRadius = CONFIG.PLAYER.pickupRadius * (1 + this.upgrades.magnet * 0.5);
                State.pickups.forEach(p => {
                    const d = Math.hypot(p.x - this.x, p.y - this.y);
                    if (d < magnetRadius) {
                        p.x += (this.x - p.x) * 0.12;
                        p.y += (this.y - p.y) * 0.12;
                    }
                });
            }

            autoAttack() {
                const target = State.findNearestEnemy(this.x, this.y);
                if (!target) return;

                const angle = Math.atan2(target.y - this.y, target.x - this.x);
                AudioEngine.playThrow();

                const count = 1 + this.upgrades.twin;
                const spread = 0.2;
                for (let i = 0; i < count; i++) {
                    const a = angle + (i - (count - 1) / 2) * spread;
                    State.projectiles.push(new FishProjectile(this.x, this.y, a, this.damage, this.upgrades.pierce));
                }
            }

            takeDamage(amt) {
                if (this.iFrameTimer > 0 || this.isDashing) return;
                this.hp -= amt;
                this.iFrameTimer = CONFIG.PLAYER.iFrameDuration;
                AudioEngine.playHit();
                Renderer.addCameraShake(5);

                ParticlePool.spawn(this.x, this.y - 10, 0, -1, '#ef4444', 0, 0.8, 'text', `-${Math.round(amt)}`);
                UI.syncHUD();

                if (this.hp <= 0) {
                    this.hp = 0;
                    State.triggerGameOver();
                }
            }

            addXP(amt) {
                const xpMult = 1 + SaveSystem.data.upgrades.xpMult * 0.2;
                this.xp += amt * xpMult;
                ParticlePool.spawn(this.x, this.y - 12, 0, -1, '#38bdf8', 0, 0.6, 'text', `+${Math.round(amt)} XP`);

                while (this.xp >= this.xpNeeded) {
                    this.xp -= this.xpNeeded;
                    this.level++;
                    this.xpNeeded = Math.round(20 + this.level * 18);
                    AudioEngine.playLevelUp();
                    State.pendingLevelUps++;
                }
                UI.syncHUD();
                if (State.pendingLevelUps > 0 && !State.isSelectingUpgrade) {
                    UI.showLevelUpModal();
                }
            }

            draw(ctx) {
                if (this.iFrameTimer > 0 && Math.floor(Date.now() / 60) % 2 === 0) return;

                ctx.save();
                ctx.translate(this.x, this.y);

                // Shadow
                ctx.beginPath();
                ctx.ellipse(0, 14, 16, 7, 0, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(0,0,0,0.3)';
                ctx.fill();

                // Body Bobbing
                const bob = Math.sin(this.waddle) * 2;
                ctx.translate(0, bob);

                // Body Outer
                ctx.beginPath();
                ctx.ellipse(0, 0, 14, 16, 0, 0, Math.PI * 2);
                ctx.fillStyle = '#0f172a';
                ctx.fill();

                // White Belly
                ctx.beginPath();
                ctx.ellipse(0, 3, 10, 12, 0, 0, Math.PI * 2);
                ctx.fillStyle = '#f8fafc';
                ctx.fill();

                // Eyes
                ctx.fillStyle = '#0f172a';
                ctx.beginPath(); ctx.arc(-4, -4, 2, 0, Math.PI * 2); ctx.fill();
                ctx.beginPath(); ctx.arc(4, -4, 2, 0, Math.PI * 2); ctx.fill();

                // Orange Beak & Feet
                ctx.fillStyle = '#f97316';
                ctx.beginPath();
                ctx.moveTo(-3, -1); ctx.lineTo(3, -1); ctx.lineTo(0, 4); ctx.closePath();
                ctx.fill();

                ctx.beginPath(); ctx.arc(-6, 14, 3, 0, Math.PI * 2); ctx.fill();
                ctx.beginPath(); ctx.arc(6, 14, 3, 0, Math.PI * 2); ctx.fill();

                ctx.restore();
            }
        }

        class FishProjectile {
            constructor(x, y, angle, damage, pierce = 0) {
                this.x = x; this.y = y;
                this.angle = angle;
                this.speed = 8.5;
                this.damage = damage;
                this.pierce = pierce;
                this.radius = 8;
                this.dead = false;
            }

            update(dt) {
                this.x += Math.cos(this.angle) * this.speed * dt * 60;
                this.y += Math.sin(this.angle) * this.speed * dt * 60;

                if (this.x < 0 || this.x > CONFIG.CANVAS.width || this.y < 0 || this.y > CONFIG.CANVAS.height) {
                    this.dead = true;
                }
            }

            draw(ctx) {
                ctx.save();
                ctx.translate(this.x, this.y);
                ctx.rotate(this.angle);

                ctx.fillStyle = '#38bdf8';
                ctx.beginPath();
                ctx.ellipse(0, 0, 10, 5, 0, 0, Math.PI * 2);
                ctx.fill();

                ctx.beginPath();
                ctx.moveTo(-8, 0); ctx.lineTo(-14, -4); ctx.lineTo(-14, 4); ctx.closePath();
                ctx.fill();

                ctx.restore();
            }
        }

        class Enemy {
            constructor(typeKey, isElite = false) {
                const c = CONFIG.ENEMIES[typeKey] || CONFIG.ENEMIES.CHASER;
                this.typeKey = typeKey;
                this.name = c.name;
                this.isElite = isElite;

                const areaMult = 1 + (State.currentArea - 1) * 0.45;
                this.maxHp = c.hp * areaMult * (isElite ? 2.5 : 1);
                this.hp = this.maxHp;
                this.speed = c.speed * (isElite ? 1.15 : 1);
                this.size = c.size * (isElite ? 1.3 : 1);
                this.xp = c.xp * (isElite ? 2.5 : 1);
                this.color = c.color;

                this.x = 0; this.y = 0;
                this.dead = false;
                this.telegraphTimer = 0;
                this.isCharging = false;
                this.chargeAngle = 0;
            }

            update(dt) {
                if (!State.player) return;
                const angle = Math.atan2(State.player.y - this.y, State.player.x - this.x);

                if (this.typeKey === 'CHARGER') {
                    if (!this.isCharging && Math.hypot(State.player.x - this.x, State.player.y - this.y) < 160 && Math.random() < 0.02) {
                        this.isCharging = true;
                        this.telegraphTimer = 0.6;
                        this.chargeAngle = angle;
                    }

                    if (this.isCharging) {
                        this.telegraphTimer -= dt;
                        if (this.telegraphTimer <= 0) {
                            this.x += Math.cos(this.chargeAngle) * this.speed * 3.2 * dt * 60;
                            this.y += Math.sin(this.chargeAngle) * this.speed * 3.2 * dt * 60;
                            if (Math.random() < 0.1) this.isCharging = false;
                        }
                    } else {
                        this.x += Math.cos(angle) * this.speed * dt * 60;
                        this.y += Math.sin(angle) * this.speed * dt * 60;
                    }
                } else {
                    this.x += Math.cos(angle) * this.speed * dt * 60;
                    this.y += Math.sin(angle) * this.speed * dt * 60;
                }

                // Collision with Player
                const dist = Math.hypot(State.player.x - this.x, State.player.y - this.y);
                if (dist < this.size + State.player.radius) {
                    State.player.takeDamage(12 * (1 + State.currentArea * 0.2));
                }
            }

            takeDamage(amt) {
                this.hp -= amt;
                AudioEngine.playHit();
                ParticlePool.spawn(this.x, this.y - 10, 0, -1, '#ffffff', 0, 0.6, 'text', `${Math.round(amt)}`);

                if (this.hp <= 0 && !this.dead) {
                    this.dead = true;
                    AudioEngine.playKill();
                    State.player.addXP(this.xp);

                    // Drop Coin / HP Pickup
                    const coinMult = 1 + SaveSystem.data.upgrades.coinMult * 0.2;
                    const coinAmt = Math.round((this.isElite ? 5 : 2) * coinMult);
                    State.pickups.push({ x: this.x, y: this.y, type: 'COIN', value: coinAmt, life: 10 });

                    if (Math.random() < 0.15) {
                        State.pickups.push({ x: this.x + 10, y: this.y, type: 'HP', value: 15, life: 10 });
                    }
                }
            }

            draw(ctx) {
                ctx.save();
                ctx.translate(this.x, this.y);

                // Charger Telegraph
                if (this.isCharging && this.telegraphTimer > 0) {
                    ctx.save();
                    ctx.rotate(this.chargeAngle);
                    ctx.fillStyle = 'rgba(239, 68, 68, 0.35)';
                    ctx.fillRect(0, -10, 160, 20);
                    ctx.restore();
                }

                // Shadow
                ctx.beginPath();
                ctx.ellipse(0, this.size * 0.7, this.size, this.size * 0.4, 0, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(0,0,0,0.3)';
                ctx.fill();

                // Elite Ring
                if (this.isElite) {
                    ctx.beginPath();
                    ctx.arc(0, 0, this.size + 4, 0, Math.PI * 2);
                    ctx.strokeStyle = '#f59e0b';
                    ctx.lineWidth = 2;
                    ctx.stroke();
                }

                // Body
                ctx.beginPath();
                ctx.arc(0, 0, this.size, 0, Math.PI * 2);
                ctx.fillStyle = this.color;
                ctx.fill();

                ctx.restore();
            }
        }

        class BossFROSTFANG {
            constructor() {
                this.name = "FROSTFANG";
                this.maxHp = 900 * (1 + (State.currentArea - 1) * 0.6);
                this.hp = this.maxHp;
                this.size = 42;
                this.x = CONFIG.CANVAS.width / 2;
                this.y = 120;
                this.speed = 1.3;
                this.phase = 1; // 1, 2, 3
                this.attackTimer = 2.0;
                this.telegraphTimer = 0;
                this.isTelegraphing = false;
                this.dead = false;
            }

            update(dt) {
                if (!State.player) return;

                // Phase Transitions
                const pct = this.hp / this.maxHp;
                if (pct <= 0.33 && this.phase < 3) {
                    this.phase = 3;
                    this.speed = 2.0;
                    AudioEngine.playBossWarning();
                    Renderer.addCameraShake(8);
                } else if (pct <= 0.66 && this.phase < 2) {
                    this.phase = 2;
                    this.speed = 1.6;
                    AudioEngine.playBossWarning();
                }

                UI.syncBossHUD();

                // Movement & Attack AI
                const angle = Math.atan2(State.player.y - this.y, State.player.x - this.x);
                this.x += Math.cos(angle) * this.speed * dt * 60;
                this.y += Math.sin(angle) * this.speed * dt * 60;

                this.attackTimer -= dt;
                if (this.attackTimer <= 0) {
                    this.attackTimer = (this.phase === 3 ? 1.5 : (this.phase === 2 ? 2.2 : 3.0));
                    this.executePattern(angle);
                }

                const dist = Math.hypot(State.player.x - this.x, State.player.y - this.y);
                if (dist < this.size + State.player.radius) {
                    State.player.takeDamage(22 * (this.phase === 3 ? 1.4 : 1.0));
                }
            }

            executePattern(angle) {
                Renderer.addCameraShake(3);
                AudioEngine.playBossWarning();

                const shots = (this.phase === 3 ? 7 : (this.phase === 2 ? 5 : 3));
                const spread = 0.25;
                for (let i = 0; i < shots; i++) {
                    const a = angle + (i - (shots - 1) / 2) * spread;
                    State.enemyProjectiles.push({
                        x: this.x, y: this.y,
                        vx: Math.cos(a) * 5, vy: Math.sin(a) * 5,
                        radius: 6, dead: false
                    });
                }
            }

            takeDamage(amt) {
                this.hp -= amt;
                AudioEngine.playHit();
                ParticlePool.spawn(this.x, this.y - 20, 0, -1, '#ef4444', 0, 0.7, 'text', `${Math.round(amt)}`);

                if (this.hp <= 0 && !this.dead) {
                    this.dead = true;
                    AudioEngine.playKill();
                    State.player.addXP(300);
                    SaveSystem.data.coins += 50 * State.currentArea;
                    Renderer.addCameraShake(12);
                }
            }

            draw(ctx) {
                ctx.save();
                ctx.translate(this.x, this.y);

                // Shadow
                ctx.beginPath();
                ctx.ellipse(0, this.size * 0.8, this.size * 1.1, this.size * 0.4, 0, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(0,0,0,0.4)';
                ctx.fill();

                // Phase Aura
                ctx.beginPath();
                ctx.arc(0, 0, this.size + 8, 0, Math.PI * 2);
                ctx.strokeStyle = (this.phase === 3 ? '#ef4444' : (this.phase === 2 ? '#f59e0b' : '#38bdf8'));
                ctx.lineWidth = 3;
                ctx.stroke();

                // Boss Body
                ctx.beginPath();
                ctx.arc(0, 0, this.size, 0, Math.PI * 2);
                ctx.fillStyle = '#0284c7';
                ctx.fill();

                ctx.restore();
            }
        }

        /* === G. STATE & MAIN ENGINE === */
        const State = {
            isRunning: false,
            isPaused: false,
            currentArea: 1,
            currentRoom: 1,
            roomType: "NORMAL ROOM",
            player: null,
            enemies: [],
            projectiles: [],
            enemyProjectiles: [],
            pickups: [],
            boss: null,
            pendingLevelUps: 0,
            isSelectingUpgrade: false,
            runCoins: 0,
            runKills: 0,
            runTime: 0,
            rafId: null,
            lastTime: 0,

            init() {
                Input.init();
                Renderer.init();
                UI.init();
                this.resetRun();
                this.loop(0);
            },

            startRun(area = 1) {
                this.currentArea = area;
                this.currentRoom = 1;
                this.runCoins = 0;
                this.runKills = 0;
                this.runTime = 0;
                this.pendingLevelUps = 0;
                this.isSelectingUpgrade = false;

                this.resetRunEntities();
                this.player = new Player();
                this.isRunning = true;
                this.isPaused = false;

                UI.hideAllModals();
                UI.showHUD(true);
                this.spawnRoom();
                UI.showAreaBanner(`AREA ${this.currentArea}: ${CONFIG.AREAS[this.currentArea].name}`);
            },

            resetRunEntities() {
                this.enemies = [];
                this.projectiles = [];
                this.enemyProjectiles = [];
                this.pickups = [];
                this.boss = null;
                ParticlePool.clear();
            },

            resetRun() {
                this.isRunning = false;
                this.isPaused = false;
                this.resetRunEntities();
                this.player = null;
                UI.showHUD(false);
                UI.showModal('modal-main-menu');
            },

            spawnRoom() {
                this.resetRunEntities();
                const types = ["NORMAL ROOM", "ELITE ROOM", "TREASURE ROOM", "REST ROOM"];
                this.roomType = (this.currentRoom === 5 ? "BOSS ROOM" : types[Math.floor(Math.random() * (this.currentRoom === 1 ? 1 : types.length))]);

                UI.syncHUD();
                const bossHud = document.getElementById('boss-hud');
                if (bossHud) bossHud.style.display = (this.currentRoom === 5 ? 'block' : 'none');

                if (this.currentRoom === 5) {
                    this.boss = new BossFROSTFANG();
                } else if (this.roomType === "TREASURE ROOM") {
                    this.pickups.push({ x: CONFIG.CANVAS.width / 2, y: CONFIG.CANVAS.height / 2, type: 'COIN', value: 30, life: 30 });
                } else if (this.roomType === "REST ROOM") {
                    if (this.player) this.player.hp = Math.min(this.player.maxHp, this.player.hp + this.player.maxHp * 0.3);
                } else {
                    const count = (this.roomType === "ELITE ROOM" ? 3 : 4) + this.currentRoom + this.currentArea;
                    for (let i = 0; i < count; i++) {
                        const keys = ['CHASER', 'RANGED', 'CHARGER', 'HEAVY'];
                        const k = keys[Math.floor(Math.random() * keys.length)];
                        const e = new Enemy(k, this.roomType === "ELITE ROOM" || Math.random() < 0.15);
                        e.x = 80 + Math.random() * (CONFIG.CANVAS.width - 160);
                        e.y = 80 + Math.random() * (CONFIG.CANVAS.height - 160);
                        this.enemies.push(e);
                    }
                }
            },

            findNearestEnemy(x, y) {
                if (this.boss && !this.boss.dead) return this.boss;
                let near = null, minDist = Infinity;
                this.enemies.forEach(e => {
                    if (!e.dead) {
                        const d = Math.hypot(e.x - x, e.y - y);
                        if (d < minDist) { minDist = d; near = e; }
                    }
                });
                return near;
            },

            checkRoomClear() {
                if (!this.isRunning || this.isPaused || this.isSelectingUpgrade) return;

                const enemiesDead = this.enemies.every(e => e.dead);
                const bossDead = this.boss ? this.boss.dead : true;

                if (enemiesDead && bossDead) {
                    this.isPaused = true;
                    const bonusCoins = 10 + this.currentRoom * 3;
                    const bonusXP = 15 + this.currentRoom * 5;
                    SaveSystem.data.coins += bonusCoins;
                    this.runCoins += bonusCoins;
                    SaveSystem.save();

                    UI.showRoomClearModal(bonusCoins, bonusXP);
                }
            },

            pause() {
                if (!this.isRunning) return;
                this.isPaused = true;
                UI.showModal('modal-pause');
            },

            resume() {
                this.isPaused = false;
                UI.hideModal('modal-pause');
            },

            triggerGameOver() {
                this.isRunning = false;
                SaveSystem.save();
                UI.showGameOverModal();
            },

            loop(time) {
                const dt = Math.min(0.05, (time - this.lastTime) / 1000 || 0.016);
                this.lastTime = time;

                if (this.isRunning && !this.isPaused) {
                    this.runTime += dt;

                    // Update Player
                    if (this.player) this.player.update(dt);

                    // Update Player Projectiles
                    for (let i = this.projectiles.length - 1; i >= 0; i--) {
                        let p = this.projectiles[i];
                        p.update(dt);
                        if (p.dead) { this.projectiles.splice(i, 1); continue; }

                        const targets = (this.boss ? [this.boss] : this.enemies);
                        targets.forEach(e => {
                            if (!e.dead && Math.hypot(e.x - p.x, e.y - p.y) < e.size + p.radius) {
                                e.takeDamage(p.damage);
                                if (p.pierce > 0) p.pierce--;
                                else p.dead = true;
                            }
                        });
                    }

                    // Update Enemy Projectiles
                    for (let i = this.enemyProjectiles.length - 1; i >= 0; i--) {
                        let ep = this.enemyProjectiles[i];
                        ep.x += ep.vx * dt * 60;
                        ep.y += ep.vy * dt * 60;

                        if (Math.hypot(this.player.x - ep.x, this.player.y - ep.y) < this.player.radius + ep.radius) {
                            this.player.takeDamage(15);
                            this.enemyProjectiles.splice(i, 1);
                            continue;
                        }

                        if (ep.x < 0 || ep.x > CONFIG.CANVAS.width || ep.y < 0 || ep.y > CONFIG.CANVAS.height) {
                            this.enemyProjectiles.splice(i, 1);
                        }
                    }

                    // Update Enemies & Boss
                    if (this.boss && !this.boss.dead) this.boss.update(dt);
                    this.enemies.forEach(e => { if (!e.dead) e.update(dt); });

                    // Update Pickups
                    for (let i = this.pickups.length - 1; i >= 0; i--) {
                        let pk = this.pickups[i];
                        pk.life -= dt;
                        if (pk.life <= 0) { this.pickups.splice(i, 1); continue; }

                        if (Math.hypot(this.player.x - pk.x, this.player.y - pk.y) < this.player.radius + 12) {
                            if (pk.type === 'COIN') {
                                SaveSystem.data.coins += pk.value;
                                this.runCoins += pk.value;
                                AudioEngine.playCoin();
                            } else if (pk.type === 'HP') {
                                this.player.hp = Math.min(this.player.maxHp, this.player.hp + pk.value);
                            }
                            UI.syncHUD();
                            this.pickups.splice(i, 1);
                        }
                    }

                    this.checkRoomClear();
                }

                Renderer.render(dt);
                this.rafId = requestAnimationFrame((t) => this.loop(t));
            }
        };

        /* === H. RENDERER ENGINE === */
        const Renderer = {
            canvas: null,
            ctx: null,
            cameraShake: 0,
            init() {
                this.canvas = document.getElementById('gameCanvas');
                this.ctx = this.canvas.getContext('2d');
                this.resize();
                window.addEventListener('resize', () => this.resize());
            },
            resize() {
                const dpr = Math.min(window.devicePixelRatio || 1, 2);
                this.canvas.width = window.innerWidth * dpr;
                this.canvas.height = window.innerHeight * dpr;
                this.ctx.scale(dpr, dpr);
            },
            addCameraShake(amt) {
                this.cameraShake = Math.max(this.cameraShake, amt);
            },
            render(dt) {
                const ctx = this.ctx;
                const w = window.innerWidth;
                const h = window.innerHeight;

                ctx.clearRect(0, 0, w, h);

                // Camera Shake
                if (this.cameraShake > 0) {
                    this.cameraShake -= dt * CONFIG.CAMERA_SHAKE_DECAY;
                    if (this.cameraShake < 0) this.cameraShake = 0;
                }
                const sx = (Math.random() - 0.5) * this.cameraShake * 3;
                const sy = (Math.random() - 0.5) * this.cameraShake * 3;

                ctx.save();
                ctx.translate(sx, sy);

                // Scale to Fixed Virtual Resolution
                const scale = Math.min(w / CONFIG.CANVAS.width, h / CONFIG.CANVAS.height);
                const offsetX = (w - CONFIG.CANVAS.width * scale) / 2;
                const offsetY = (h - CONFIG.CANVAS.height * scale) / 2;

                ctx.translate(offsetX, offsetY);
                ctx.scale(scale, scale);

                // Area Background Floor
                const areaCfg = CONFIG.AREAS[State.currentArea] || CONFIG.AREAS[1];
                ctx.fillStyle = areaCfg.floor;
                ctx.fillRect(0, 0, CONFIG.CANVAS.width, CONFIG.CANVAS.height);

                // Grid Pattern
                ctx.strokeStyle = 'rgba(255,255,255,0.03)';
                ctx.lineWidth = 1;
                for (let x = 0; x < CONFIG.CANVAS.width; x += 40) {
                    ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, CONFIG.CANVAS.height); ctx.stroke();
                }
                for (let y = 0; y < CONFIG.CANVAS.height; y += 40) {
                    ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(CONFIG.CANVAS.width, y); ctx.stroke();
                }

                if (State.isRunning) {
                    // Pickups Render
                    State.pickups.forEach(p => {
                        ctx.fillStyle = (p.type === 'COIN' ? '#fbbf24' : '#34d399');
                        ctx.beginPath();
                        ctx.arc(p.x, p.y, (p.type === 'COIN' ? 6 : 8), 0, Math.PI * 2);
                        ctx.fill();
                    });

                    // Y-Ordering Depth Render
                    const renderList = [];
                    if (State.player) renderList.push(State.player);
                    State.enemies.forEach(e => { if (!e.dead) renderList.push(e); });
                    if (State.boss && !State.boss.dead) renderList.push(State.boss);

                    renderList.sort((a, b) => a.y - b.y);
                    renderList.forEach(obj => obj.draw(ctx));

                    // Projectiles
                    State.projectiles.forEach(p => p.draw(ctx));
                    State.enemyProjectiles.forEach(ep => {
                        ctx.fillStyle = '#ef4444';
                        ctx.beginPath();
                        ctx.arc(ep.x, ep.y, ep.radius, 0, Math.PI * 2);
                        ctx.fill();
                    });

                    // Particles & Text Overlay
                    ParticlePool.updateAndDraw(ctx, dt);
                }

                ctx.restore();
            }
        };

        /* === I. UI CONTROLLER === */
        const UI = {
            init() {
                // Main Menu Actions
                document.getElementById('btn-start').onclick = () => { AudioEngine.playClick(); State.startRun(1); };
                document.getElementById('btn-select-area').onclick = () => { AudioEngine.playClick(); this.showAreaModal(); };
                document.getElementById('btn-open-shop').onclick = () => { AudioEngine.playClick(); this.showShopModal(); };
                document.getElementById('btn-how-to').onclick = () => { AudioEngine.playClick(); this.showModal('modal-how-to'); };
                document.getElementById('btn-close-how').onclick = () => { AudioEngine.playClick(); this.hideModal('modal-how-to'); };
                document.getElementById('btn-close-area').onclick = () => { AudioEngine.playClick(); this.hideModal('modal-area'); };
                document.getElementById('btn-close-shop').onclick = () => { AudioEngine.playClick(); this.hideModal('modal-shop'); };

                // HUD Buttons
                document.getElementById('btn-pause').onclick = () => { AudioEngine.playClick(); State.pause(); };
                document.getElementById('btn-audio').onclick = () => {
                    AudioEngine.muted = !AudioEngine.muted;
                    document.getElementById('btn-audio').innerText = AudioEngine.muted ? '🔇' : '🔊';
                    SaveSystem.save();
                };

                // Pause Actions
                document.getElementById('btn-resume').onclick = () => { AudioEngine.playClick(); State.resume(); };
                document.getElementById('btn-restart-run').onclick = () => { AudioEngine.playClick(); State.startRun(State.currentArea); };
                document.getElementById('btn-quit-main').onclick = () => { AudioEngine.playClick(); State.resetRun(); };

                // Modal Room Clear & Over
                document.getElementById('btn-next-room').onclick = () => {
                    AudioEngine.playClick();
                    this.hideModal('modal-room-clear');
                    State.isPaused = false;
                    if (State.currentRoom < 5) {
                        State.currentRoom++;
                        State.spawnRoom();
                    } else if (State.currentArea < 4) {
                        State.currentArea++;
                        State.currentRoom = 1;
                        if (State.currentArea > SaveSystem.data.unlockedArea) {
                            SaveSystem.data.unlockedArea = State.currentArea;
                            SaveSystem.save();
                        }
                        State.spawnRoom();
                        this.showAreaBanner(`AREA ${State.currentArea}: ${CONFIG.AREAS[State.currentArea].name}`);
                    } else {
                        this.showModal('modal-victory');
                    }
                };

                document.getElementById('btn-retry').onclick = () => { AudioEngine.playClick(); State.startRun(State.currentArea); };
                document.getElementById('btn-go-main').onclick = () => { AudioEngine.playClick(); State.resetRun(); };
                document.getElementById('btn-vic-main').onclick = () => { AudioEngine.playClick(); State.resetRun(); };

                // Reset Data
                document.getElementById('btn-reset-data').onclick = () => {
                    if (confirm("Reset seluruh data game dan koin permanen?")) {
                        SaveSystem.reset();
                        this.showToast("Data berhasil di-reset!");
                        this.showShopModal();
                    }
                };

                // Student Footer Init
                document.getElementById('student-info-text').innerText = `Nama: ${STUDENT_INFO.name} | Kelas: ${STUDENT_INFO.class}`;
            },

            showModal(id) {
                const el = document.getElementById(id);
                if (el) el.classList.add('active');
            },

            hideModal(id) {
                const el = document.getElementById(id);
                if (el) el.classList.remove('active');
            },

            hideAllModals() {
                document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
            },

            showHUD(visible) {
                document.getElementById('ui-layer').style.display = visible ? 'flex' : 'none';
            },

            syncHUD() {
                if (!State.player) return;
                const p = State.player;
                document.getElementById('hud-level').innerText = `LV. ${p.level}`;
                document.getElementById('hud-area-title').innerText = CONFIG.AREAS[State.currentArea].name;
                document.getElementById('hud-room-text').innerText = `ROOM ${State.currentRoom} / 5`;
                document.getElementById('hud-room-type').innerText = State.roomType;
                document.getElementById('hud-coins').innerText = SaveSystem.data.coins;

                const hpPct = Math.max(0, (p.hp / p.maxHp) * 100);
                document.getElementById('hp-bar-fill').style.width = `${hpPct}%`;
                document.getElementById('hp-text').innerText = `${Math.ceil(p.hp)} / ${p.maxHp}`;

                const xpPct = Math.min(100, (p.xp / p.xpNeeded) * 100);
                document.getElementById('xp-bar-fill').style.width = `${xpPct}%`;

                // Dash Overlay
                const dashPct = Math.max(0, (p.dashTimer / p.dashCd) * 100);
                document.getElementById('dash-cd-overlay').style.height = `${dashPct}%`;
            },

            syncBossHUD() {
                if (!State.boss) return;
                const b = State.boss;
                document.getElementById('boss-name').innerText = b.name;
                document.getElementById('boss-phase').innerText = `PHASE ${b.phase}`;
                const pct = Math.max(0, (b.hp / b.maxHp) * 100);
                document.getElementById('boss-hp-fill').style.width = `${pct}%`;
            },

            showAreaBanner(text) {
                const el = document.getElementById('area-banner');
                document.getElementById('area-banner-text').innerText = text;
                el.classList.add('show');
                setTimeout(() => el.classList.remove('show'), 2200);
            },

            showLevelUpModal() {
                if (State.isSelectingUpgrade || !State.player) return;
                State.isSelectingUpgrade = true;
                State.isPaused = true;

                const container = document.getElementById('upgrade-cards');
                container.innerHTML = '';

                // Random 3 Unique Upgrades
                const p = State.player;
                const available = CONFIG.UPGRADES.filter(u => (p.upgrades[u.id] || 0) < u.maxLvl);
                const shuffled = [...available].sort(() => 0.5 - Math.random()).slice(0, 3);

                shuffled.forEach(upg => {
                    const currLvl = p.upgrades[upg.id] || 0;
                    const card = document.createElement('div');
                    card.className = 'upgrade-card';
                    card.innerHTML = `
                        <div style="display:flex; justify-content:space-between; font-size:12px; font-weight:800;">
                            <span style="color:#38bdf8;">${upg.name}</span>
                            <span style="color:#fbbf24;">LV. ${currLvl} ➔ ${currLvl + 1}</span>
                        </div>
                        <div style="font-size:11px; color:#94a3b8; margin-top:4px;">${upg.desc}</div>
                    `;
                    card.onclick = () => {
                        AudioEngine.playClick();
                        p.upgrades[upg.id] = currLvl + 1;
                        if (upg.id === 'hp') { p.maxHp += 25; p.hp += 25; }
                        else if (upg.id === 'spd') { p.speed += 0.3; }

                        this.hideModal('modal-upgrade');
                        State.pendingLevelUps--;
                        State.isSelectingUpgrade = false;

                        if (State.pendingLevelUps > 0) {
                            this.showLevelUpModal();
                        } else {
                            State.isPaused = false;
                        }
                    };
                    container.appendChild(card);
                });

                this.showModal('modal-upgrade');
            },

            showRoomClearModal(coins, xp) {
                document.getElementById('rc-heal').innerText = `+${Math.round(State.player.maxHp * 0.1)} HP (BONUS)`;
                document.getElementById('rc-coins').innerText = `🐟 +${coins} KOIN`;
                document.getElementById('rc-xp').innerText = `+${xp} XP`;
                this.showModal('modal-room-clear');
            },

            showGameOverModal() {
                document.getElementById('go-area').innerText = State.currentArea;
                document.getElementById('go-room').innerText = State.currentRoom;
                document.getElementById('go-coins').innerText = State.runCoins;
                document.getElementById('go-kills').innerText = State.runKills;
                const sec = Math.floor(State.runTime);
                document.getElementById('go-time').innerText = `${Math.floor(sec / 60)}m ${sec % 60}s`;
                this.showModal('modal-game-over');
            },

            showAreaModal() {
                const list = document.getElementById('area-list');
                list.innerHTML = '';
                for (let a = 1; a <= 4; a++) {
                    const area = CONFIG.AREAS[a];
                    const unlocked = a <= SaveSystem.data.unlockedArea;
                    const card = document.createElement('div');
                    card.className = 'glass-panel';
                    card.style.cssText = `padding: 12px; display:flex; justify-content:space-between; align-items:center; cursor:${unlocked ? 'pointer' : 'not-allowed'}; opacity:${unlocked ? 1 : 0.5};`;
                    card.innerHTML = `
                        <div>
                            <div style="font-size:12px; font-weight:800; color:#38bdf8;">AREA ${a}</div>
                            <div style="font-size:14px; font-weight:900; color:#fff;">${area.name}</div>
                        </div>
                        <div>${unlocked ? '🔓' : '🔒'}</div>
                    `;
                    if (unlocked) {
                        card.onclick = () => {
                            AudioEngine.playClick();
                            this.hideModal('modal-area');
                            State.startRun(a);
                        };
                    }
                    list.appendChild(card);
                }
                this.showModal('modal-area');
            },

            showShopModal() {
                document.getElementById('shop-coins').innerText = SaveSystem.data.coins;
                const list = document.getElementById('shop-list');
                list.innerHTML = '';

                CONFIG.SHOP.forEach(item => {
                    const lvl = SaveSystem.data.upgrades[item.id] || 0;
                    const isMax = lvl >= item.maxLvl;
                    const cost = Math.round(item.baseCost * Math.pow(item.costMult, lvl));
                    const canAfford = SaveSystem.data.coins >= cost && !isMax;

                    const card = document.createElement('div');
                    card.className = 'glass-panel';
                    card.style.cssText = `padding: 10px 14px; display:flex; justify-content:space-between; align-items:center;`;
                    card.innerHTML = `
                        <div>
                            <div style="font-size:13px; font-weight:800; color:#fff;">${item.name} <span style="font-size:10px; color:#f59e0b;">(${lvl}/${item.maxLvl})</span></div>
                            <div style="font-size:10px; color:#94a3b8;">${item.desc}</div>
                        </div>
                        <button class="btn-ui" style="width:auto; padding:6px 12px; margin:0; font-size:11px; background:${canAfford ? 'linear-gradient(135deg, #f59e0b, #d97706)' : '#334155'}; cursor:${canAfford ? 'pointer' : 'not-allowed'};">
                            ${isMax ? 'MAX' : '🐟 ' + cost}
                        </button>
                    `;
                    const btn = card.querySelector('button');
                    if (canAfford) {
                        btn.onclick = () => {
                            AudioEngine.playClick();
                            SaveSystem.data.coins -= cost;
                            SaveSystem.data.upgrades[item.id] = lvl + 1;
                            SaveSystem.save();
                            this.showToast(`Upgrade ${item.name} Berhasil!`);
                            this.showShopModal();
                        };
                    }
                    list.appendChild(card);
                });
                this.showModal('modal-shop');
            },

            showToast(msg) {
                const toast = document.getElementById('toast');
                toast.innerText = msg;
                toast.classList.add('show');
                setTimeout(() => toast.classList.remove('show'), 2000);
            }
        };

        /* === J. ENGINE BOOTSTRAP === */
        window.addEventListener('DOMContentLoaded', () => {
            State.init();
        });
    </script>
</body>
</html>
```
