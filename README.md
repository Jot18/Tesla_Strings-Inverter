# Powerwall Strings & Inverter

A small, **single-file** web app that reads **per-string (MPPT)** and **inverter** data from a
Tesla Powerwall‑3 gateway over its **local API** (TEDAPI) — no cloud, no Tesla account — and
charts it in your browser. The data collector and the web page are the same program.

- 📈 Per-string energy, live power/voltage, and an inverter overview (AC output, cooling fan, grid Hz/V)
- 🗓️ Time ranges (3h → All) plus a custom From/to date filter
- 📊 Four charts: string power, string voltage, AC output + fan, grid frequency + voltage
- ⬇️ One-click **Excel export** of the selected window
- 🔌 Auto-adapts to **any number of strings** (up to 10 distinct colors)

## Screenshots
<h3 align="center">Strings &amp; Inverter</h3>

<p align="center">
  <img
    src="https://github.com/user-attachments/assets/6eabda6a-279d-4362-ae9d-3166298e187a"
    alt="Strings and Inverter Dashboard"
    width="900"
  />
</p>


## Requirements

- A Tesla Powerwall (PW2/+/3) gateway you can reach on your network
- Python 3.11+
- Python packages (installed automatically by the launcher): `flask`, `openpyxl`, `pypowerwall`

---

## 1. Get your Gateway password

The app logs in to the gateway's local TEDAPI using the **Gateway Wi‑Fi password**, which is
printed on the gateway's label/QR sticker:

- **Powerwall 2 / Powerwall+ (Backup Gateway 2):** open the gateway's front cover — the label
  lists a Wi‑Fi network name and a **Password**.
- **Powerwall 3:** the QR/label is behind the cover of the **first PW3** (the system controller).
  If you don't have it recorded, you may need to request it from Tesla.

> Some gateways' default password is the **last 5 characters of the gateway serial/ID**, but the
> value printed on the label is authoritative — use what's on the sticker.

## 2. Connect to the gateway (Wi‑Fi adapter)

Your PC must be able to reach the gateway at **`192.168.91.1`** by joining the gateway's own Wi‑Fi:

1. On the gateway label, find its Wi‑Fi network name:
   - PW2/+: **`TEG-XXX`** (XXX = last 3 digits of the gateway serial)
   - PW3: **`TeslaPW_XXXXXX`**
2. Connect your PC's Wi‑Fi to that network using the Wi‑Fi password from the label.
3. The gateway is now reachable at `192.168.91.1` (the default `TEDAPI_HOST`).
4. Set that adapter to **auto-reconnect** so logging keeps running after Wi‑Fi blips.

> The gateway's Wi‑Fi has **no internet access**. If you need internet at the same time, use a
> second adapter (Ethernet or a second Wi‑Fi).

---

## 3. Run it (Windows)

1. Install Python 3.11+ from [python.org](https://www.python.org/downloads/) and tick **“Add python.exe to PATH”**.
2. Unzip this folder anywhere.
3. Open **`Start_StringsPage.bat`** in Notepad and set the top lines:
```bat
   set "TEDAPI_HOST=192.168.91.1"
   set "TEDAPI_PASSWORD=YOUR_GATEWAY_PASSWORD"
   set "PORT=8800"
   set "INTERVAL=60"
```
4. **Double-click `Start_StringsPage.bat`.** The first run installs dependencies (~1 min, one-time),
   then starts collecting and opens `http://localhost:8800/`. Keep the window open; closing it
   (or Ctrl+C) stops everything.

## Sample vs. real data

The included `StringsDB.db` holds 14 days of **synthetic** data so the page looks populated out of
the box. To view just the sample data without a gateway, run
`python strings_server.py --no-collect --port 8800`. To start logging **your** data, delete
`StringsDB.db` (it is recreated automatically) and run the launcher.

## Files

| File | Purpose |
|------|---------|
| `strings_server.py` | The whole app — collector + web viewer + launcher |
| `Start_StringsPage.bat` | Windows launcher (edit host/password/port inside) |
| `requirements.txt` | `flask` + `openpyxl` + `pypowerwall` |
| `StringsDB.db` | 14 days of sample data (replaced by your real data once logging) |

[Powerwall-Strings-Inverter.zip](https://github.com/user-attachments/files/28935178/Powerwall-Strings-Inverter.zip)

## Security note

The gateway password is stored in plain text inside `Start_StringsPage.bat`.
