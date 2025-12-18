---
title: "Vultr Firewall पूर्ण गाइड: क्लाउड सर्वर सुरक्षा सेटअप"
date: 2025-12-16T16:00:00+09:00
lastmod: 2025-12-16T16:00:00+09:00
draft: false
description: "Vultr के वेब-आधारित फ़ायरवॉल का उपयोग करके क्लाउड सर्वर को सुरक्षित करने के लिए संपूर्ण गाइड। Firewall Groups बनाने से लेकर व्यावहारिक कार्यान्वयन तक।"
tags: ["vultr", "firewall", "방화벽", "서버보안", "vps", "클라우드보안", "인프라"]
categories: ["클라우드"]
image: "https://images.urinfo24.com/featured/vultr-firewall-setup-guide-featured.jpg"
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

## 1. Vultr Firewall क्या है?

Vultr Firewall एक वेब-आधारित फ़ायरवॉल सेवा है।
यह आपके क्लाउड इंस्टेंस तक ट्रैफ़िक पहुंचने से पहले पैकेट फ़िल्टर करता है।

### 1.1 आपको इसकी आवश्यकता क्यों है?

सर्वर सुरक्षा के लिए गहन रक्षा की आवश्यकता होती है।
केवल होस्ट फ़ायरवॉल (UFW, firewalld) पर्याप्त नहीं है।

Vultr Firewall नेटवर्क स्तर पर काम करता है।
इसलिए, दुर्भावनापूर्ण ट्रैफ़िक आपके सर्वर तक पहुंचने से पहले ब्लॉक हो जाता है।

### 1.2 होस्ट फ़ायरवॉल से अंतर

**होस्ट फ़ायरवॉल (UFW, firewalld):**
- सर्वर OS के अंदर काम करता है
- सर्वर तक पहुंचने के बाद ट्रैफ़िक फ़िल्टर करता है
- CPU/मेमोरी संसाधनों का उपयोग करता है

**Vultr Firewall:**
- Vultr के नेटवर्क स्तर पर काम करता है
- सर्वर तक पहुंचने से पहले ट्रैफ़िक ब्लॉक करता है
- सर्वर संसाधनों पर कोई प्रभाव नहीं

इसलिए, दोनों को एक साथ उपयोग करना सबसे सुरक्षित तरीका है।

### 1.3 Firewall Group अवधारणा

Vultr Firewall समूहों में प्रबंधित किया जाता है।
आप एक Firewall Group में कई नियम जोड़ते हैं।
फिर आप इस समूह को कई इंस्टेंस पर लागू कर सकते हैं।

उदाहरण के लिए:
- वेब सर्वर समूह: HTTP/HTTPS की अनुमति दें
- DB सर्वर समूह: केवल विशिष्ट IP से DB पोर्ट की अनुमति दें
- विकास सर्वर समूह: केवल SSH की अनुमति दें


## 2. Firewall Group बनाना

### 2.1 पोर्टल के माध्यम से बनाना

Vultr Customer Portal में लॉगिन करें।

1. **Products → Network → Firewall** पर नेविगेट करें
2. **Add Firewall** बटन पर क्लिक करें
3. **Description** फ़ील्ड में समूह नाम दर्ज करें
4. **Add Firewall Group** बटन पर क्लिक करें

समूह बन गया है।
लेकिन अभी भी यह बिना नियमों वाला खाली समूह है।

### 2.2 API के माध्यम से बनाना

API का उपयोग स्वचालन सक्षम करता है।

```bash
curl "https://api.vultr.com/v2/firewalls" \
  -X POST \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "description": "web-server-firewall"
  }'
```

आपको प्रतिक्रिया में Firewall Group ID प्राप्त होगी।
इस ID को याद रखें।

### 2.3 Terraform के साथ प्रबंधन

यदि आप कोड के रूप में इंफ्रास्ट्रक्चर प्रबंधित करते हैं, तो Terraform का उपयोग करें।

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}
```

कोड प्रबंधन संस्करण नियंत्रण सक्षम करता है।
टीम सहयोग के लिए भी सुविधाजनक है।

## 3. फ़ायरवॉल नियम कॉन्फ़िगर करना

### 3.1 बुनियादी नियम जोड़ना

नियम प्रबंधन स्क्रीन में प्रवेश करने के लिए Firewall Group पर क्लिक करें।

**IPv4 नियम जोड़ें:**
- Protocol: TCP
- Port: 80
- Source: Anywhere (0.0.0.0/0)

यह कहीं से भी HTTP एक्सेस की अनुमति देता है।

### 3.2 SSH एक्सेस को प्रतिबंधित करना

SSH केवल विशिष्ट IP से एक्सेस योग्य होना चाहिए।

**IPv4 नियम:**
- Protocol: TCP
- Port: 22
- Source: 123.45.67.89 (आपका IP)

अब SSH एक्सेस केवल आपके IP से संभव है।
अन्य IP ब्लॉक हैं।

### 3.3 एक साथ कई पोर्ट खोलना

वेब सर्वर को HTTP और HTTPS दोनों खोलने की आवश्यकता है।

**नियम 1 - HTTP:**
```
Protocol: TCP
Port: 80
Source: 0.0.0.0/0
```

**नियम 2 - HTTPS:**
```
Protocol: TCP
Port: 443
Source: 0.0.0.0/0
```

### 3.4 API के माध्यम से नियम जोड़ना

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

स्वचालन स्क्रिप्ट में उपयोगी।

### 3.5 Terraform में नियम परिभाषित करना

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

## 4. इंस्टेंस से कनेक्ट करना

### 4.1 पोर्टल के माध्यम से कनेक्ट करना

एक बार जब आप नियम बना लेते हैं, तो उन्हें इंस्टेंस पर लागू करें।

1. **Products → Compute** पर नेविगेट करें
2. लक्ष्य इंस्टेंस पर क्लिक करें
3. **Settings → Firewall** पर जाएं
4. Firewall ड्रॉपडाउन से समूह चुनें
5. **Update Firewall Group** बटन पर क्लिक करें

तुरंत लागू हो गया।

### 4.2 कई इंस्टेंस पर लागू करना

यदि आपके पास एक ही भूमिका वाले कई सर्वर हैं?
प्रत्येक इंस्टेंस पर एक ही Firewall Group लागू करें।

उदाहरण के लिए:
- 3 वेब सर्वर
- सभी को एक ही फ़ायरवॉल नियमों की आवश्यकता है

इसलिए, तीनों पर एक Firewall Group लागू करें।
नियम परिवर्तन तुरंत तीनों पर प्रतिबिंबित होते हैं।

### 4.3 API के माध्यम से कनेक्ट करना

```bash
curl "https://api.vultr.com/v2/instances/{instance-id}" \
  -X PATCH \
  -H "Authorization: Bearer ${VULTR_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
    "firewall_group_id": "{firewall-id}"
  }'
```

स्वचालित परिनियोजन स्क्रिप्ट में उपयोग करें।

### 4.4 Terraform के साथ प्रबंधन

```hcl
resource "vultr_instance" "web" {
  region             = "sea"
  plan               = "vc2-1c-1gb"
  os_id              = 1743  # Ubuntu 22.04
  label              = "web-server-01"
  firewall_group_id  = vultr_firewall_group.web.id
}
```

इंस्टेंस निर्माण के साथ साथ फ़ायरवॉल लागू करें।

## 5. व्यावहारिक उपयोग उदाहरण

### 5.1 वेब सर्वर की सुरक्षा

वेब सर्वर को केवल HTTP, HTTPS और SSH खोलने की आवश्यकता है।

```hcl
resource "vultr_firewall_group" "web" {
  description = "Web Server Firewall"
}

resource "vultr_firewall_rule" "web_ssh" {
  firewall_group_id = vultr_firewall_group.web.id
  protocol          = "tcp"
  port              = "22"
  ip_type           = "v4"
  subnet            = "123.45.67.89"  # केवल आपका IP
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

अन्य सभी पोर्ट स्वचालित रूप से ब्लॉक हो जाते हैं।

### 5.2 डेटाबेस सर्वर

DB सर्वर केवल वेब सर्वर से एक्सेस योग्य होना चाहिए।

```hcl
resource "vultr_firewall_rule" "db_from_web" {
  firewall_group_id = vultr_firewall_group.db.id
  protocol          = "tcp"
  port              = "5432"  # PostgreSQL
  ip_type           = "v4"
  subnet            = "192.168.1.10"  # वेब सर्वर का निजी IP
  subnet_size       = 32
}
```

सार्वजनिक IP के माध्यम से DB तक पहुंच नहीं हो सकती।
केवल निजी नेटवर्क के माध्यम से संभव है।

### 5.3 Load Balancer के साथ एकीकरण

यदि Load Balancer का उपयोग कर रहे हैं?
वेब सर्वर को केवल Load Balancer से ट्रैफ़िक प्राप्त करना चाहिए।

**नियम सेटिंग्स:**
- Protocol: TCP
- Port: 80
- Source: Load Balancer (LB ID दर्ज करें)

यह Load Balancer को बायपास करने वाली सीधी पहुंच को ब्लॉक करता है।

## 6. सुरक्षा सर्वोत्तम प्रथाएं

### 6.1 डिफ़ॉल्ट नीति: सभी को अस्वीकार करें

Vultr Firewall की डिफ़ॉल्ट नीति "सभी को ब्लॉक करें" है।
इसलिए, केवल स्पष्ट रूप से अनुमत ट्रैफ़िक ही गुजरता है।

यह सही दृष्टिकोण है।
केवल आवश्यक को खोलें।

### 6.2 न्यूनतम विशेषाधिकार का सिद्धांत

सभी IP के लिए SSH न खोलें।
यह ब्रूट फोर्स हमलों का लक्ष्य बन जाता है।

इसलिए, केवल विशिष्ट IP की अनुमति दें:
- कार्यालय IP
- VPN IP
- घर का IP

### 6.3 गहन रक्षा

क्या केवल Vultr Firewall पर्याप्त है?
नहीं। होस्ट फ़ायरवॉल का भी एक साथ उपयोग करें।

**रक्षा परतें:**
1. Vultr Firewall (नेटवर्क स्तर)
2. होस्ट फ़ायरवॉल (OS स्तर)
3. एप्लिकेशन फ़ायरवॉल (ऐप स्तर)

इसलिए, UFW या firewalld भी कॉन्फ़िगर करें।

### 6.4 उत्पादन से पहले परीक्षण

यदि आप फ़ायरवॉल को गलत तरीके से कॉन्फ़िगर करते हैं?
सेवा रुकावट।

इसलिए, हमेशा:
1. विकास वातावरण में परीक्षण करें
2. स्टेजिंग वातावरण में सत्यापित करें
3. उत्पादन में लागू करें

### 6.5 नियमित नियम समीक्षा

यह एक बार का सेटअप नहीं है।
नियमित रूप से नियमों की समीक्षा करें:

- अनावश्यक नियम हटाएं
- अब उपयोग नहीं किए जाने वाले IP हटाएं
- नई सुरक्षा आवश्यकताओं को प्रतिबिंबित करें

## 7. समस्या निवारण

### 7.1 जब कनेक्शन विफल हो

SSH या वेब एक्सेस नहीं कर सकते?

**चेकलिस्ट:**
1. क्या Firewall Group इंस्टेंस से जुड़ा है?
2. क्या पोर्ट की अनुमति देने वाला नियम है?
3. क्या स्रोत IP सही है?
4. होस्ट फ़ायरवॉल भी जांचें

### 7.2 नियम लागू करने का समय

Firewall Group परिवर्तन तुरंत लागू होते हैं।
लेकिन नेटवर्क प्रसार में कुछ सेकंड लग सकते हैं।

10-20 सेकंड के बाद कनेक्शन परीक्षण का प्रयास करें।

### 7.3 लॉग जांचना

Vultr Firewall स्वयं लॉग प्रदान नहीं करता है।
इसलिए, होस्ट फ़ायरवॉल लॉग जांचें।

**UFW लॉग:**
```bash
sudo tail -f /var/log/ufw.log
```

**Firewalld लॉग:**
```bash
sudo journalctl -u firewalld -f
```

### 7.4 नियम प्राथमिकता

Vultr Firewall में नियम क्रम नहीं है।
सभी नियम OR शर्त के साथ काम करते हैं।

यानी, यदि कोई नियम मेल खाता है, तो इसकी अनुमति है।

## 8. CLI और स्वचालन

### 8.1 Vultr CLI स्थापित करना

```bash
# macOS
brew install vultr/vultr-cli/vultr-cli

# Linux
curl -L https://github.com/vultr/vultr-cli/releases/latest/download/vultr-cli-linux-amd64.tar.gz | tar xz
sudo mv vultr-cli /usr/local/bin/
```

API Key कॉन्फ़िगर करें:
```bash
export VULTR_API_KEY="your-api-key"
```

### 8.2 Firewall Groups प्रबंधित करना

**समूह सूचीबद्ध करें:**
```bash
vultr-cli firewall group list
```

**समूह बनाएं:**
```bash
vultr-cli firewall group create --description "Web Server"
```

**नियम जोड़ें:**
```bash
vultr-cli firewall rule create \
  --firewall-group-id <id> \
  --protocol tcp \
  --port 80 \
  --ip-type v4 \
  --subnet 0.0.0.0 \
  --subnet-size 0
```

### 8.3 परिनियोजन स्वचालन

नए इंस्टेंस को परिनियोजित करते समय स्वचालित रूप से फ़ायरवॉल लागू करें:

```bash
#!/bin/bash

# इंस्टेंस बनाएं
INSTANCE_ID=$(vultr-cli instance create \
  --region sea \
  --plan vc2-1c-1gb \
  --os 1743 \
  --label web-server \
  --output json | jq -r '.id')

# फ़ायरवॉल लागू करें
vultr-cli instance update-firewall-group \
  --instance-id $INSTANCE_ID \
  --firewall-group-id $FIREWALL_ID

echo "Instance $INSTANCE_ID deployed with firewall"
```

## 9. लागत और सीमाएं

### 9.1 लागत

Vultr Firewall **पूरी तरह से निःशुल्क** है।
कोई अतिरिक्त शुल्क नहीं।

इसलिए, सभी इंस्टेंस के लिए अनुशंसित।

### 9.2 सीमाएं

**Firewall Groups:**
- प्रति खाता अधिकतम 50

**नियम:**
- प्रति समूह अधिकतम 50 नियम

अधिकांश मामलों के लिए पर्याप्त है।
यदि अधिक की आवश्यकता है तो समर्थन से संपर्क करें।

### 9.3 Load Balancer Firewall से अंतर

Vultr Load Balancer का एक अलग फ़ायरवॉल है।
दोनों अलग हैं:

**Vultr Firewall:**
- इंस्टेंस की सुरक्षा करता है
- नेटवर्क स्तर फ़िल्टरिंग

**Load Balancer Firewall:**
- Load Balancer की सुरक्षा करता है
- LB में प्रवेश करने वाले ट्रैफ़िक को फ़िल्टर करता है

इसलिए, Load Balancer का उपयोग करते समय दोनों को कॉन्फ़िगर करें।

## 10. सारांश

### 10.1 Vultr Firewall के लाभ

- निःशुल्क
- नेटवर्क स्तर सुरक्षा
- कई इंस्टेंस पर आसान अनुप्रयोग
- API/CLI/Terraform समर्थन
- कोई सर्वर संसाधन उपयोग नहीं

### 10.2 कब उपयोग करें?

**अवश्य उपयोग करें:**
- उत्पादन सर्वर
- सार्वजनिक सेवाएं
- संवेदनशील डेटा प्रोसेसिंग

**वैकल्पिक:**
- विकास/परीक्षण वातावरण
- केवल निजी नेटवर्क का उपयोग करने वाले सर्वर

लेकिन यदि संभव हो तो सभी इंस्टेंस पर लागू करें।

### 10.3 अतिरिक्त सुरक्षा संवर्द्धन

Vultr Firewall के अलावा:
- Fail2ban इंस्टॉल करें (ब्रूट फोर्स ब्लॉक करें)
- SSH key प्रमाणीकरण का उपयोग करें
- नियमित सुरक्षा अपडेट
- DDoS सुरक्षा सक्षम करें

कई सुरक्षा परतों की आवश्यकता है।

### 10.4 संदर्भ

- [Vultr Firewall आधिकारिक दस्तावेज़](https://docs.vultr.com/products/network/firewall)
- [Vultr API दस्तावेज़](https://www.vultr.com/api/)
- [Vultr CLI GitHub](https://github.com/vultr/vultr-cli)
- [Terraform Vultr Provider](https://registry.terraform.io/providers/vultr/vultr/latest/docs)

Vultr Firewall का उपयोग करके क्लाउड सर्वर को सुरक्षित रूप से सुरक्षित करें।
यह निःशुल्क और उपयोग में आसान है।
इसलिए, अभी सेटअप करें।
