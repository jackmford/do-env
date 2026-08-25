# do-tf

DigitalOcean infrastructure for the personal website and related small services.

## Operate

### Setup

Terraform uses the local `DO_PAT` environment variable and the existing SSH
private key. Neither belongs in Git.

```sh
terraform init
```

Pass both values when planning or applying:

```sh
terraform plan -var "do_token=$DO_PAT" -var "pvt_key=$HOME/.ssh/id_rsa"
```

### Validate and apply

Back up the local state before changing infrastructure or DNS. This repository
uses local Terraform state, so do not run Terraform concurrently from another
machine.

```sh
cp terraform.tfstate "terraform.tfstate.$(date +%Y%m%d%H%M%S).bak"
terraform fmt -check
terraform validate
terraform plan -out=change.tfplan -var "do_token=$DO_PAT" -var "pvt_key=$HOME/.ssh/id_rsa"
terraform apply change.tfplan
```

Review the plan before applying it. State files, variable files, plans, and
local credentials are ignored by Git.

### Current layout

- `node-2` runs Ubuntu 24.04 and serves `jackmitchellfordyce.com`.
- The apex A record is managed by `digitalocean_record.A-jmf` with a 30-minute
  TTL. Do not replace it with a `digitalocean_domain` resource: changing that
  resource can recreate the whole zone.
- `node-1-before-ubuntu-24-04` is retained as an unmanaged rollback snapshot.

### Verify the website

```sh
curl -fsS https://jackmitchellfordyce.com/health
dig +short @ns1.digitalocean.com jackmitchellfordyce.com A
```

After a DNS change, check the other DigitalOcean nameservers as well. Recursive
resolvers can retain the previous answer for the record TTL.

### Website server replacement

1. Create the replacement droplet alongside the current one.
2. Provision it with `ansible/playbooks/personal_website.yml` using a temporary
   inventory entry.
3. Verify Caddy, `/health`, and the site directly against the replacement.
4. Change only `digitalocean_record.A-jmf` to cut over the apex site.
5. Keep the old server for 24-48 hours before destroying it.
