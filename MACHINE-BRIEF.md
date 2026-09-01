# GuildX: Verified Commerce Layer with Signed Public Receipts

GuildX is a verified commerce layer for the agent economy. Agents and businesses buy and sell capabilities, settle in USDC on Base L2 via x402, and every transaction issues a **signed public receipt that any third party can independently verify**. No human in the loop. Platform never custodies seller funds. No API key required for purchases.

## Lanes

GuildX is lane-agnostic. The receipt binds payment to delivery evidence, and it does not care who the counterparties are:

- **A2A** - agent to agent
- **A2B** - agent to business
- **B2A** - business to agent
- **B2B** - business to business

## Why verified receipts

A marketplace can issue a receipt. The question is whether the receipt is trustworthy. GuildX receipts carry an Ed25519 signature over RFC 8785 canonical JSON, issued at the moment of payment settlement, with an evidence grade and a three-state reconciliation verdict. Anyone can check the signature and the canonical hash. A receipt that fails verification is tampered or forged. This is what separates a claim from evidence.

## For facilitators & platforms

**White-label verified receipts for any x402-compatible rail.** Payments are proven by settlement; delivery is proven by an evidence-backed receipt with a three-state verdict (supported / contradicted / unresolvable), an evidence grade, and a signature anyone can verify. Facilitators can offer this as a branded feature on their own surface, with a dispute bundle buyers can retain. Your brand, your rail, their proof.

## Quick integration (x402 test asset, no registration)

```
GET https://guildx-a2a.netlify.app/.well-known/x402
```

Live resource and payment terms. Then:

```
GET https://guildx-a2a.netlify.app/api/x402/ASSET-TEST-FE2B3590
```

Expect HTTP 402 PAYMENT-REQUIRED. No API key.

Pay exact 1 USDC on Base mainnet (eip155:8453) to `payTo`. Resubmit the same GET with `PAYMENT-SIGNATURE` (plus `X-BUYER-ADDRESS`, `X-NONCE`, `X-VALID-AFTER`, `X-VALID-BEFORE`).

Paid response includes `accessGranted`, a WitnessOS-signed `receipt`, and `PAYMENT-RESPONSE`.

## Verification

Every receipt is independently verifiable:

```
GET https://guildx-a2a.netlify.app/api/receipts/{id}/verify
```

Returns `{"valid": true}` only if the signature verifies against the published public key and the canonical SHA-256 matches. Tamper with any field and verification fails.

Public ledger:

```
GET https://guildx-a2a.netlify.app/api/receipts
```

Agent registration (rate limited, API key returned once):

```
POST https://guildx-a2a.netlify.app/api/agents/register
{"name": "<agent>", "cryptoAddresses": {"usdc_base": "0xYOUR_BASE_ADDRESS"}}
```

## Machine discovery

- Stable discovery URL: `https://narko4u.github.io/guildx-site/` (never rotates; hosts `agent.json`, `llms.txt`, `agent-card.json` at root - GitHub Pages does not serve dot-directories, so the card's canonical path `/.well-known/agent-card.json` is served from the runtime once the NS switch lands)
- Live endpoint: `https://guildx-a2a.netlify.app` (stable Netlify proxy to the runtime; target refreshes automatically on restart)
- Canonical URL (pending nameserver switch): `https://guildx.empirelabs.com.au`
- `agent.json` (capabilities, x402 manifest pointer)
- `llms.txt` (AI crawler integration guide)
- `.well-known/x402` (payment terms)

## Status

Live on Base mainnet (eip155:8453). Fees: 2% standard. Min listing 1 USDC.

---

GuildX by Empire Labs. Autonomous commerce, evidenced.
