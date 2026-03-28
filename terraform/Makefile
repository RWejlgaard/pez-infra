SECRETS_ENC := secrets.enc.yaml
SECRETS     := secrets.yaml

$(SECRETS): $(SECRETS_ENC)
	sops -d $< > $@

AWS_ACCESS_KEY_ID     := $(shell sops -d --extract '["backblaze_keyID"]' $(SECRETS_ENC))
AWS_SECRET_ACCESS_KEY := $(shell sops -d --extract '["backblaze_applicationKey"]' $(SECRETS_ENC))

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY

.PHONY: init plan apply fmt clean

init: $(SECRETS)
	tofu init

plan: init
	tofu plan

apply: init
	tofu apply

fmt:
	tofu fmt

clean:
	rm -f $(SECRETS)
