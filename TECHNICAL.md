# World Cup Fan Zone — Technical Documentation

**TxODDS × Solana World Cup Hackathon · Consumer & Fan Experiences track**

---

## Core idea

World Cup Fan Zone turns following the 2026 World Cup into a game anyone can play. You predict the entire knockout bracket by tapping winners, and every real result is **verified on-chain by TxLINE** before it locks and scores your picks. Each upcoming match shows a live win probability sourced from TxLINE odds, and a "Smart Picks" model estimates who the market is underpricing to win it all. One self-contained HTML file, zero backend, instant demo mode, and a real Solana wallet flow for live data.

## How it works (data flow)

1. **Wallet + subscription (Solana, on-chain).** The user connects a Solana wallet (Phantom). The app runs TxLINE's on-chain `subscribe` instruction for the **free World Cup tier** via Anchor (IDL fetched on-chain with `Program.at`), creating the user's TxL token account idempotently in the same transaction. Devnet is the default so testers use a free SOL airdrop.
2. **Activation (off-chain).** The app gets a guest JWT, signs the binding message `${txSig}::${jwt}` with the wallet, and activates an API token.
3. **Verified data (off-chain, anchored on-chain).** Using `Authorization: Bearer <jwt>` + `X-Api-Token: <token>`, the app pulls fixtures, scores and odds. Because every TxLINE packet is timestamped on Solana, a locked result is tamper-evident.
4. **App logic.** Scores lock bracket results and score the user's picks; odds drive the per-match win % and the Smart Picks market line; a Poisson/Elo Monte-Carlo (form-adjusted by every played game) fills in unplayed rounds.

## TxLINE endpoints used

**Auth / subscription**
- `POST /auth/guest/start` — anonymous guest JWT.
- On-chain `subscribe(serviceLevel, weeks)` — TxLINE program (devnet `6pW64gN1s2uqjHkn1unFeEjAwJkPGHoppGvS715wyP2J`, mainnet `9ExbZjAapQww1vfcisDmrngPinHTEfpjYRWMunJgcKaA`); free World Cup service level `1` (devnet) / `1` or `12` (mainnet).
- `POST /api/token/activate` — exchanges the confirmed `txSig` + wallet signature for an API token.

**Data**
- `GET /api/fixtures/snapshot` — fixtures (`FixtureId`, `Participant1/2`, `Participant1IsHome`, `GameState`); used to map feed fixtures to FIFA match numbers.
- `GET /api/scores/snapshot/{fixtureId}` — verified scores; decoded via the TxODDS soccer spec (`game_finalised` event; Stat keys `1`/`2` = goals, `6001`/`6002` = shootout goals). Drives result verification, bracket locking, and pick scoring.
- `GET /api/odds/snapshot/{fixtureId}` — StablePrice demargined odds; the `1X2_PARTICIPANT_RESULT` market's `Pct` array drives per-match win % (green) and, propagated through the bracket, the Smart Picks market column.

## Technical highlights

- **On-chain verification as the product spine.** Results only "lock" when TxLINE reports them final; because TxLINE anchors each packet on Solana, a scoreline can't be spoofed to steal fan-card points.
- **Real, resilient integration.** Real endpoint shapes and the soccer stat encoding are handled exactly; the odds parser prefers the full-match 1X2 but falls back to a period line (draw-split recovers a near-identical advance probability), and last-known odds are retained across the feed's rolling snapshot buffer.
- **Form-adjusted model.** A World Football Elo engine (K=60, goal-margin weighted, neutral venues, shootouts as draws) replays all 72 group games + every knockout so the model reflects tournament form, not just seeds — toggleable against the frozen ratings.
- **Zero-backend, instant demo.** A single HTML file with an offline demo seed (real results through the quarter-finals) so judges see every feature immediately, then a one-click live mode.

## Business highlights

- **Mass-market fan hook, not a trader tool.** Bracket pick'em + shareable fan card is the kind of viral, low-friction experience that drives daily engagement during a tournament — the exact audience TxLINE wants to reach beyond sportsbooks.
- **Trust by design.** "Verified on-chain" is a differentiator for prediction/fan products where disputed results erode trust; TxLINE makes that a one-line integration.
- **Extensible.** The same verified feed powers pick-em leagues, group competitions, loyalty rewards, or settlement for on-chain prediction markets — a natural upsell path from the free World Cup tier to paid league coverage.

## Run it

- **Demo:** open `WorldCup-FanZone.html` in any browser.
- **Live:** serve over `http://localhost` (double-click `Run-FanZone.command`, or `python3 -m http.server`), connect Phantom on devnet with a little airdropped SOL, click **Go live with TxLINE**, then **Refresh results**.

*Not affiliated with FIFA. Demo result seed via worldcupwiki.com; live data via TxLINE.*
