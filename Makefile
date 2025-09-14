.PHONY: sync-agents check-agents

AGENTS_ROOT := AGENTS.md
COPILOT_FILE := .github/copilot-instructions.md

sync-agents:
	@mkdir -p .github
	cp $(AGENTS_ROOT) $(COPILOT_FILE)
	@echo "Synced $(AGENTS_ROOT) -> $(COPILOT_FILE)"

check-agents:
	@mkdir -p .github
	@touch $(COPILOT_FILE)
	@diff -q $(AGENTS_ROOT) $(COPILOT_FILE) >/dev/null || \
	  (echo "AGENTS.md and $(COPILOT_FILE) are out of sync. Run 'make sync-agents'." >&2; \
	   diff -u $(AGENTS_ROOT) $(COPILOT_FILE) || true; \
	   exit 1)
