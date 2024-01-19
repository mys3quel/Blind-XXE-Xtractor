# Blind XXE Xtractor BETA

Blind XXE Xtractor is a script created for educational purpose to test Blind XXE vulnerabilities in controlled environments, which has support for local and remote websites with XML requests. It's in BETA because I tested almost everything but it would give errors, so if you find an error please report it and I will try to fix it.

**WARNING!**  It might fail with some XML requests so don't completely believe it, try some manual methods to be sure.

## Prerequisites

- Some basic tools like *curl*
- [Burp Suite](https://portswigger.net/burp/releases#community)
- [Ngrok](https://ngrok.com/download) (Optional)

## Installation

### 1 Clone the repository

```bash
git clone https://github.com/mys3quel/Blind-XXE-Xtractor && cd Blind-XXE-Xtractor && chmod +x Blind-XXE-Xtractor.sh && ./Blind-XXE-Xtractor.sh
```

## Remote configure

### 1 Install Ngrok

```bash
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
```
[Download Ngrok](https://ngrok.com/download)

### 2 Configure Ngrok

```bash
ngrok config add-authtoken your_token_here
```
[Get your token here](https://dashboard.ngrok.com/get-started/your-authtoken)

## Usage

```bash
./Blind-XXE-Xtractor.sh -h
```

### Examples

#### Run script in guide mode
```bash
./Blind-XXE-Xtractor.sh -g
```

#### Read the /etc/hosts of the victim machine using the exported request from BurpSuite
```bash
./Blind-XXE-Xtractor.sh -b burpFile -f /etc/hosts
```

#### Read the /etc/passwd of the victim machine using the exported request from BurpSuite and a custom port for the connection
```bash
./Blind-XXE-Xtractor.sh -b burpFile -f /etc/passwd -p 90
```
