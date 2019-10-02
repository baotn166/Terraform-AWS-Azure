FROM alpine:3.10.2

ENV TERRAFORM_VERSION 0.12.9

RUN apk --update --no-cache add libc6-compat git openssh-client python py-pip python3 curl jq && pip install awscli

RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

WORKDIR /automation

COPY run.sh values-template.tfvars ./
COPY terraform ./terraform
COPY ec2.pem ~/

RUN chmod +x run.sh
RUN chmod 400 ~/ec2.pem

ENV PATH="/automation:$PATH"