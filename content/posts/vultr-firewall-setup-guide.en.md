---
title: "Complete Vultr Firewall Guide: Cloud Server Security Setup"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "Complete guide to securing cloud servers using Vultr's web-based firewall. From creating Firewall Groups to practical implementation."
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://urinfo24.com/cdn-cgi/image/width=1200,format=auto,quality=85/https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
lightgallery: true
---

<!--
IMAGE PROMPT FOR AI IMAGE GENERATOR:

A professional, technical illustration depicting cloud firewall security concept.
- Style: Clean, modern technical diagram style with minimalist design
- Subject: Network firewall shield icon protecting cloud server instances
- Elements: Firewall shield in center, multiple server icons behind it, network traffic arrows (green for allowed, red for blocked), cloud infrastructure background
- Colors: Blue and white for security theme, green for allowed traffic, red for blocked traffic, gray for servers
- Mood: Professional, secure, trustworthy, technical
- Composition: Central firewall shield with bidirectional traffic flow visualization

Technical keywords: Vultr, firewall, cloud security, network protection, server infrastructure

SAVE AS: /home/freein/blog/urfreein.github.io/static/images/vultr-firewall-setup-guide-featured.jpg

NOTE: Hugo will serve this from /images/vultr-firewall-setup-guide-featured.jpg
-->

## 1. What is Vultr Firewall?

Vultr Firewall is a web-based firewall service.
It filters packets before traffic reaches your cloud instances.

### 1.1 Why Do You Need It?

Server security requires defense in depth.
Host firewalls (UFW, firewalld) alone are not enough.

Vultr Firewall operates at the network level.
Therefore, malicious traffic is blocked before reaching your server.

### 1.2 Difference from Host Firewalls

**Host Firewall (UFW, firewalld):**
- Operates within the server OS
- Filters traffic after it reaches the server
- Uses CPU/memory resources

**Vultr Firewall:**
- Operates at Vultr's network level
- Blocks traffic before it reaches the server
- No impact on server resources

Therefore, using both together is the safest approach.

### 1.3 Firewall Group Concept

Vultr Firewall is managed in groups.
You add multiple rules to one Firewall Group.
Then you can apply this group to multiple instances.

For example:
- Web server group: Allow HTTP/HTTPS
- DB server group: Allow DB port only from specific IPs
- Development server group: Allow SSH only


## 2. Creating a Firewall Group

### 2.1 Creating via Portal

Log in to Vultr Customer Portal.

1. Navigate to **Products → Network → Firewall**
2. Click **Add Firewall** button
3. Enter group name in **Description** field
4. Click **Add Firewall Group** button

The group is created.
But it's still an empty group with no rules.

### 2.2 Creating via API

Using the API enables automation.

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

You'll receive a Firewall Group ID in response.
Remember this ID.

### 2.3 Managing with Terraform

If you manage infrastructure as code, use Terraform.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

Code management enables version control.
It's also convenient for team collaboration.

## 3. Configuring Firewall Rules

### 3.1 Adding Basic Rules

Click the Firewall Group to enter rule management screen.

**Add IPv4 Rule:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

This allows HTTP access from anywhere.

### 3.2 Restricting SSH Access

SSH should only be accessible from specific IPs.

**IPv4 Rule:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (your IP)

Now SSH access is only possible from your IP.
Other IPs are blocked.

### 3.3 Opening Multiple Ports at Once

Web servers need both HTTP and HTTPS open.

**Rule 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**Rule 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 Adding Rules via API

```bash
curl "https://api.vultr.com/v2/firewalls/{firewall-id}/rules" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "ip_type": "v4",
    "protocol": "tcp",
    "subnet": "0.0.0.0",
    "subnet_size": 0,
    "port": "80",
    "notes": "Allow HTTP"
  }'
```

Useful in automation scripts.

### 3.5 Defining Rules in Terraform

```hcl
resource "vultr_firewall_rule" "allow_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "80"
  notes             = "Allow HTTP traffic"
}

resource "vultr_firewall_rule" "allow_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "443"
  notes             = "Allow HTTPS traffic"
}

resource "vultr_firewall_rule" "allow_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "123.45.67.89"
  subnet_size       = 32
  port              = "22"
  notes             = "Allow SSH from my IP"
}
```

## 4. Connecting to Instances

### 4.1 Connecting via Portal

Once you've created rules, apply them to instances.

1. Navigate to **Products → Compute**
2. Click target instance
3. Go to **Settings → Firewall**
4. Select group from Firewall dropdown
5. Click **Update Firewall Group** button

Applied immediately.

### 4.2 Applying to Multiple Instances

What if you have multiple servers with the same role?
Apply the same Firewall Group to each instance.

For example:
- 3 web servers
- All need same firewall rules

Therefore, apply one Firewall Group to all 3.
Rule changes are immediately reflected on all 3.

### 4.3 Connecting via API

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

Use in automated deployment scripts.

### 4.4 Managing with Terraform

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

Apply firewall simultaneously with instance creation.

## 5. Practical Usage Examples

### 5.1 Protecting Web Servers

Web servers only need HTTP, HTTPS, and SSH open.

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # Your IP only
  subnet_size       = 32
}

resource "vultr_firewall_rule" "web_http" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "80"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}

resource "vultr_firewall_rule" "web_https" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "443"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
}
```

All other ports are automatically blocked.

### 5.2 Database Servers

DB servers should only be accessible from web servers.

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # Web server private IP
  subnet_size       = 32
}
```

DB cannot be accessed via public IP.
Only possible through Private Network.

### 5.3 Integration with Load Balancer

If using a Load Balancer?
Web servers should only receive traffic from the Load Balancer.

**Rule settings:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (enter LB ID)

This blocks direct access bypassing the Load Balancer.

## 6. Security Best Practices

### 6.1 Default Policy: Deny All

Vultr Firewall's default policy is "block all".
Therefore, only explicitly allowed traffic passes through.

This is the correct approach.
Only open what's necessary.

### 6.2 Principle of Least Privilege

Don't open SSH to all IPs.
It becomes a target for brute force attacks.

Therefore, allow only specific IPs:
- Office IP
- VPN IP
- Home IP

### 6.3 Defense in Depth

Is Vultr Firewall alone enough?
No. Use host firewalls together.

**Defense layers:**
1. Vultr Firewall (network level)
2. Host firewall (OS level)
3. Application firewall (app level)

Therefore, configure UFW or firewalld as well.

### 6.4 Test Before Production

What if you misconfigure the firewall?
Service interruption. ㅠ.ㅠ

Therefore, always:
1. Test in development environment
2. Verify in staging environment
3. Apply to production

### 6.5 Regular Rule Review

It's not a one-time setup.
Review rules regularly:

- Delete unnecessary rules
- Remove IPs no longer in use
- Reflect new security requirements

## 7. Troubleshooting

### 7.1 When Connection Fails

Can't access SSH or web?

**Checklist:**
1. Is Firewall Group connected to instance?
2. Is there a rule allowing the port?
3. Is the source IP correct?
4. Check host firewall too

### 7.2 Rule Application Time

Firewall Group changes apply immediately.
But network propagation may take a few seconds.

Try connection test after 10-20 seconds.

### 7.3 Checking Logs

Vultr Firewall itself doesn't provide logs.
Therefore, check host firewall logs.

**UFW logs:**
```bash
sudo tail -f /var/log/ufw.log
```

**Firewalld logs:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 Rule Priority

Vultr Firewall has no rule ordering.
All rules work with OR condition.

That is, if any rule matches, it's allowed.

## 8. CLI and Automation

### 8.1 Installing Vultr CLI

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

Configure API Key:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Managing Firewall Groups

**List groups:**
```bash
vultr-cli firewall group list
```

**Create group:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**Add rule:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 Deployment Automation

Automatically apply firewall when deploying new instances:

```bash
#!/bin/bash

# Create instance
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# Apply firewall
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. Costs and Limitations

### 9.1 Costs

Vultr Firewall is **completely free**.
No additional charges at all.

Therefore, recommended for all instances.

### 9.2 Limitations

**Firewall Groups:**
- Maximum 50 per account

**Rules:**
- Maximum 50 rules per group

Sufficient for most cases.
Contact support if you need more.

### 9.3 Difference from Load Balancer Firewall

Vultr Load Balancer has a separate firewall.
The two are different:

**Vultr Firewall:**
- Protects instances
- Network level filtering

**Load Balancer Firewall:**
- Protects Load Balancer
- Filters traffic entering LB

Therefore, configure both when using Load Balancer.

## 10. Summary

### 10.1 Advantages of Vultr Firewall

- Free
- Network level protection
- Easy application to multiple instances
- API/CLI/Terraform support
- No server resource usage

### 10.2 When to Use?

**Must use:**
- Production servers
- Public services
- Sensitive data processing

**Optional:**
- Development/test environments
- Servers using only Private Network

But apply to all instances if possible.

### 10.3 Additional Security Enhancements

Besides Vultr Firewall:
- Install Fail2ban (block brute force)
- Use SSH key authentication
- Regular security updates
- Enable DDoS Protection

Multiple layers of security are needed.

### 10.4 References

- [Vultr Firewall Official Documentation](https://docs.vultr.com/products/network/firewall)
- [Vultr API Documentation](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

Using Vultr Firewall protects cloud servers safely.
It's free and easy to use.
Therefore, set it up right now.
