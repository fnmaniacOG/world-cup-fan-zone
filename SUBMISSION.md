# World Cup Fan Zone

**TxODDS × Solana World Cup Hackathon — Consumer & Fan Experiences track**

A free, one-file web app that turns following the 2026 World Cup into a game: call the entire knockout bracket, watch every result get **verified live on-chain by TxLINE**, bank points as your picks come true, and peek at a model that flags which teams the market is underpricing.

---

## The one-liner

> Predict the bracket. TxLINE verifies reality on Solana. You score points and see the value.

## Why it fits Consumer & Fan Experiences

It is built for everyone watching the tournament, not for traders. No jargon required to play:

- **Tap-to-pick bracket challenge** — click a team to send it through; winners carry forward all the way to the trophy. Each upcoming game shows a **live win %** for both teams (TxLINE odds when connected, model estimate in demo).
- **Fan card** — live points, accuracy, correct-pick count, and a one-tap shareable card for group chats and X.
- **Live score ticker** — every finished game with a "✓ Verified on-chain" badge.
- **Smart Picks (optional)** — a Monte-Carlo model that plays the remaining bracket forward and shows who is underpriced vs the market, for the fans who want an edge.

It runs from a single HTML file with zero backend, so anyone can open it instantly.

## How TxLINE is the primary input

TxLINE is not decoration — it is the source of truth the whole experience is built on:

1. **Result verification & lock-in.** Scores come from the TxLINE World Cup feed. A game only "locks" (turns green, scores your pick, eliminates the loser) once TxLINE reports it final. Because every TxLINE packet is timestamped on Solana, a locked result is **tamper-evident** — nobody can fake a scoreline to steal points.
2. **The market line.** When live, the Smart Picks model uses **TxLINE outright odds** as the market column, so "edge" = model title odds − TxLINE-implied odds. Offline it falls back to editable demo prices.
3. **Fixtures & schedule.** The bracket structure and kickoff metadata map to TxLINE fixtures by FIFA match number (M73–M104).

### Integration flow (World Cup free tier)

Implemented in the `TXLINE` module exactly per the [TxLINE World Cup free-tier docs](https://txline.txodds.com/documentation/worldcup):

1. Connect a Solana wallet (Phantom).
2. On-chain `subscribe(serviceLevel, 4 weeks)` to the free World Cup tier — devnet service level `1`, mainnet `1` (60s) or `12` (real-time). The Anchor program IDL is fetched **on-chain** via `Program.at()`, so no IDL file is bundled.
3. `POST /auth/guest/start` → guest JWT; sign `${txSig}::${jwt}` with the wallet; `POST /api/token/activate` → API token.
4. Data calls send `Authorization: Bearer <jwt>` + `X-Api-Token: <token>`.

**Real endpoints + encoding (verified against the live TxLINE docs/feed):**

- `GET /api/fixtures/snapshot` → `{ FixtureId, Participant1, Participant2, Participant1IsHome, StartTime, GameState }`.
- `GET /api/scores/snapshot/{fixtureId}` → stat records decoded with the TxODDS soccer encoding: key `1`/`2` = Participant 1/2 total goals, `6001`/`6002` = penalty-shootout goals; game phase `5` (F) / `10` (FET) / `13` (FPE) = finished (13 = decided on penalties).
- The 32 knockout **fixtureIds are pre-mapped** from the TxLINE World Cup schedule feed to FIFA match numbers M73–M102, and feed team names are reconciled to ours (e.g. `Ivory Coast → Côte d'Ivoire`, `USA → United States`, `Cape Verde → Cabo Verde`). Matches are walked in bracket order so each result resolves the next round's participants.

Networks, program IDs, mints and hosts are taken straight from the docs (devnet + mainnet both configured; devnet is the default so testers can use a free SOL airdrop).

## Try it in 10 seconds (demo mode)

1. Open `WorldCup-FanZone.html` in any browser.
2. It loads with the **real 2026 results through the quarter-finals** (as of Jul 13) pre-verified, so every feature works immediately — the four semifinalists (France, Spain, England, Argentina) are live and the semis + final are yours to call.
3. Tap teams in unplayed games to make your picks; open **Smart Picks → Run model** to see value.

Your picks and prices are saved automatically (URL hash + localStorage), so a refresh never loses them.

## Go live with TxLINE

Click **◎ Go live with TxLINE**, approve the wallet connection and the free-tier subscription. Notes:

- You need a small amount of SOL on the selected network for the on-chain fee (devnet: use a free airdrop).
- Browsers block API calls from `file://`, so for the live feed serve the file locally, e.g. `python3 -m http.server` then open `http://localhost:8000/WorldCup-FanZone.html`. Demo mode works from `file://` with no server.
- If the live payload field names differ from the assumed shape, they are mapped in one place (`ingestScores` / `ingestOdds`) for a quick adjust.

## Tech

Single self-contained `.html` file — vanilla JS, no build step. Solana libs (`@solana/web3.js`, `@coral-xyz/anchor`, `@solana/spl-token`) are loaded on demand from a CDN only when going live. Model is a Poisson/Elo Monte-Carlo over the real bracket.

## Rules checklist

- ✅ Functional build (works now in demo; live path implemented against the documented API).
- ✅ Uses **TxLINE data as a primary input** (result verification, result-locking, market line, fixtures).
- ✅ Consumer & Fan Experiences track — a fun tool anyone can use during the World Cup.
- ✅ Submission window closes **July 19, 2026**; winners announced July 29.

---

### Submission blurb (paste into Superteam Earn)

> **World Cup Fan Zone** — Predict the entire knockout bracket, then watch TxLINE verify every result live on Solana. Tap teams to pick winners, bank points as games are confirmed on-chain, share your fan card, and use the built-in value model (priced off TxLINE odds) to spot underrated teams. TxLINE is the primary input: scores lock results tamper-evidently, odds drive the market line, and fixtures map the bracket. One HTML file, zero backend, instant demo mode, real wallet-based free-tier integration. Built for the Consumer & Fan Experiences track.

*Not affiliated with FIFA. Result data via TxLINE / worldcupwiki.com for the demo seed.*
