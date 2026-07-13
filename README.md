# ⚽ World Cup Fan Zone

Predict the 2026 World Cup knockout bracket and watch every result get **verified live on-chain by TxLINE** on Solana. Built for the **TxODDS × Solana World Cup Hackathon** — Consumer & Fan Experiences track.

- **App:** `index.html` (single file, no backend)
- **Submission blurb + rules fit:** [SUBMISSION.md](SUBMISSION.md)
- **Technical docs + TxLINE endpoints:** [TECHNICAL.md](TECHNICAL.md)

## Run

**Demo (instant):** open `index.html` in any browser — loads with real results through the quarter-finals.

**Live TxLINE:** wallets and API calls need an http origin, so serve it locally:
```bash
python3 -m http.server 8765
# then open http://localhost:8765/index.html
```
(macOS: double-click `Run-FanZone.command` to do this automatically.) Connect Phantom on **devnet** with a little airdropped SOL, click **Go live with TxLINE**, then **Refresh results**.

_Not affiliated with FIFA. Demo result seed via worldcupwiki.com; live data via TxLINE._
