==================================================================
 Powerwall Strings & Inverter
==================================================================

A single-file app that reads per-string (MPPT) and inverter data from a Tesla
Powerwall-3 gateway over its LOCAL API (no cloud, no Tesla login) and serves a
web page that charts it. The collector and the web viewer are one program.

------------------------------------------------------------------
 QUICK START (Windows)
------------------------------------------------------------------
  1. Install Python 3.11+  (python.org -> tick "Add python.exe to PATH").
  2. Unzip this folder anywhere.
  3. Open  Start_StringsPage.bat  in Notepad and set the top lines:
         set "TEDAPI_HOST=192.168.91.1"      (your gateway IP)
         set "TEDAPI_PASSWORD=YOUR_PASSWORD"  (gateway local password)
  4. Double-click  Start_StringsPage.bat. The first run installs dependencies
     (~1 min), then collects data and opens http://localhost:8800/.

  You must be on the gateway's network (its "TEG-xxxx" Wi-Fi, or its LAN IP).

  Mac/Linux, or just to view the included sample data without a gateway:
     pip install -r requirements.txt
     python strings_server.py --no-collect --port 8800

------------------------------------------------------------------
 THE PAGE
------------------------------------------------------------------
  - One energy card per string: kWh, % of output, live W/V, and a colored bar.
  - Inverter tiles: AC output, cooling fan, grid frequency, grid voltage.
  - Charts: string power, string voltage, AC output + fan, grid freq + voltage.
  - Ranges 3h / 6h / 1d / 7d / 30d / 6mo / 12mo / All, plus a From/to date filter.
  - Export Excel for the current window.

------------------------------------------------------------------
 FILES
------------------------------------------------------------------
  strings_server.py       the whole app (collector + viewer + launcher)
  Start_StringsPage.bat   Windows launcher (edit host/password inside)
  requirements.txt        flask + openpyxl + pypowerwall
  StringsDB.db            14 days of sample data (your real data replaces it)
  README.txt              this file

------------------------------------------------------------------
 NOTES
------------------------------------------------------------------
  - 100% local: per-string data comes only from the gateway's local API.
  - The password is stored in plaintext in the .bat -- add yours locally.
  - The bundled StringsDB.db is sample data so the page looks populated. To log
    your own data, delete it (it is recreated) and run the launcher.
