# PE_IDP_1
An Internal Developer Platform with GKE, Terraform, ArgoCD, GitHub Actions, Snyk, Prometheus/Grafana, Google Secrets Manager, and Backstage.

## Architecture
- **Infra**: Terraform on GKE (GCS backend: gs://pe-idp-1-tfstate).
- **App**: Flask app with Secrets Manager, deployed via ArgoCD.
- **CI/CD**: GitHub Actions with Snyk.
- **Monitoring**: Prometheus/Grafana.
- **Portal**: Backstage.

## Setup
1. Clone: `git clone https://github.com/yourusername/PE_IDP_1`
2. Infra Up: `cd terraform && terraform init && terraform apply`
3. Deploy: `./manage.sh up`
4. Teardown: `./manage.sh down && cd terraform && terraform destroy`

## Screenshots
- [GKE](link)
- [Grafana](link)
- [Backstage](link)