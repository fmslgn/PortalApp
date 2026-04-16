# PortalApp

PortalApp, kullanıcıların sisteme üye olabildiği, giriş yapabildiği, şifresini yenileyebildiği ve makale işlemlerini gerçekleştirebildiği JSP/Servlet tabanlı bir web uygulamasıdır.

Bu proje; JSP, Servlet, JDBC, MySQL ve Apache Tomcat kullanılarak geliştirilmiştir.
---

## Özellikler

- Üye kayıt olma
- Üye girişi yapma
- Çıkış yapma
- Şifre yenileme
- Makale ekleme
- Makale listeleme
- Makale detay görüntüleme
- Okunma sayısı artırma
- Makale güncelleme
- Makale silme
- Session tabanlı kullanıcı kontrolü
---

## Kullanılan Teknolojiler

- Java
- JSP
- Servlet
- JDBC
- MySQL
- Apache Tomcat 10
- Eclipse IDE
- HTML
- CSS
- Bootstrap 5
---

## Proje Amacı

Bu proje, kullanıcı üyelik sistemi ve makale yönetimi mantığını öğrenmek amacıyla geliştirilmiş bir dinamik web uygulamasıdır.

Kullanıcılar sisteme kayıt olabilir, giriş yapabilir ve giriş yaptıktan sonra makale işlemlerini gerçekleştirebilir.
---

## Veritabanı Yapısı

Projede `portalapp_db` isimli bir MySQL veritabanı kullanılmaktadır.

### users tablosu

- id
- fullname
- email
- password
- profile_image
- reset_code
- created_at

### articles tablosu

- id
- user_id
- title
- content
- view_count
- created_at
- updated_at
---

## Veritabanı Kurulum Komutları

Aşağıdaki SQL komutlarını MySQL Workbench üzerinde çalıştırabilirsiniz:

``` sql
CREATE DATABASE portalapp_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE portalapp_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    reset_code VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE articles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```
---

## Gerekli Yazılımlar

Projeyi çalıştırabilmek için aşağıdaki yazılımlar gereklidir:

- JDK	
- Eclipse IDE for Enterprise Java and Web Developers
- Apache Tomcat 10
- MySQL Server
- MySQL Workbench 
---

## Kurulum Adımları

### 1. Projeyi Eclipse'e ekleyin

Projeyi Eclipse IDE üzerinde Dynamic Web Project yapısında açın.

### 2. Tomcat Server ekleyin

Apache Tomcat 10 sunucusunu Eclipse içine tanımlayın ve projeyi bu server'a bağlayın.

### 3. MySQL veritabanını oluşturun

Yukarıda verilen SQL komutları ile `portalapp_db` veritabanını ve tabloları oluşturun.

### 4. JDBC Driver ekleyin

MySQL Connector/J `.jar` dosyasını proje içindeki aşağıdaki klasöre ekleyin:

```text
src/main/webapp/WEB-INF/lib
```
### 5. Veritabanı bağlantısını düzenleyin

`DBConnection.java` dosyasındaki bağlantı bilgilerini kendi sisteminize göre ayarlayın:

```java
private static final String URL = "jdbc:mysql://localhost:3306/portalapp_db?useSSL=false&serverTimezone=UTC";
private static final String USER = "root";
private static final String PASSWORD = "SIFRENIZ";
```
### 6. Projeyi çalıştırın

Projeyi Tomcat üzerinden başlatın ve tarayıcıdan şu adrese gidin:

```text
http://localhost:8080/PortalApp/
```
---

## Uygulama Sayfaları

- `index.jsp` → Ana sayfa
- `register.jsp` → Kayıt sayfası
- `login.jsp` → Giriş sayfası
- `forgot-password.jsp` → Şifre yenileme sayfası
- `article-form.jsp` → Makale ekleme sayfası
- `articles.jsp` → Makale listeleme sayfası
- `article-detail.jsp` → Makale detay sayfası
- `edit-article.jsp` → Makale güncelleme sayfası
---

## Servlet Yapısı

- `RegisterServlet` → Kullanıcı kaydı
- `LoginServlet` → Kullanıcı girişi
- `LogoutServlet` → Çıkış işlemi
- `ForgotPasswordServlet` → Şifre güncelleme
- `AddArticleServlet` → Makale ekleme
- `UpdateArticleServlet` → Makale güncelleme
- `DeleteArticleServlet` → Makale silme
- `TestDBServlet` → Veritabanı bağlantı testi
---

## Proje Klasör Yapısı

```text
PortalApp
├─ README.md
├─ src/main/java
│  ├─ controller
│  │  ├─ RegisterServlet.java
│  │  ├─ LoginServlet.java
│  │  ├─ LogoutServlet.java
│  │  ├─ ForgotPasswordServlet.java
│  │  ├─ AddArticleServlet.java
│  │  ├─ UpdateArticleServlet.java
│  │  ├─ DeleteArticleServlet.java
│  │  └─ TestDBServlet.java
│  └─ util
│     └─ DBConnection.java
├─ src/main/webapp
│  ├─ index.jsp
│  ├─ register.jsp
│  ├─ login.jsp
│  ├─ forgot-password.jsp
│  ├─ article-form.jsp
│  ├─ articles.jsp
│  ├─ article-detail.jsp
│  ├─ edit-article.jsp
│  └─ WEB-INF
│     ├─ web.xml
│     └─ lib
│        └─ mysql-connector-j-xxxx.jar
```
---

## Uygulamada Gerçekleştirilen İşlemler

### Kullanıcı İşlemleri

- Kullanıcı kayıt olabilir
- Kullanıcı sisteme giriş yapabilir
- Kullanıcı çıkış yapabilir
- Kullanıcı şifresini güncelleyebilir

### Makale İşlemleri

- Giriş yapan kullanıcı makale ekleyebilir
- Sistemdeki makaleler listelenebilir
- Makale detay sayfası görüntülenebilir
- Makale okunma sayısı artırılabilir
- Kullanıcı kendi makalesini güncelleyebilir
- Kullanıcı kendi makalesini silebilir
---

## Güvenlik Notu

Bu proje eğitim amaçlı geliştirilmiştir.

Şifreler doğrudan veritabanında tutulmaktadır. Gerçek projelerde:

- şifreler hashlenmelidir
- doğrulama mekanizmaları eklenmelidir
- yetkilendirme kontrolleri güçlendirilmelidir
---

## Geliştirici

**Furkan Mehmet Salgın**

---

## Lisans

Bu proje eğitim ve geliştirme amaçlı paylaşılmıştır.
