.PHONY: decrypt

# Decrypt all SOPS-encrypted files (*.enc.* -> *.*)
decrypt:
	@find . -name "*.enc.*" ! -name "*.example" -not -path "./.git/*" | while read f; do \
		out=$$(echo "$$f" | sed 's/\.enc\././'); \
		sops -d "$$f" > "$$out"; \
	done
