# Mango Microservices

Aplikasi e-commerce berbasis **.NET 8** dengan arsitektur microservices, API Gateway (Ocelot), komunikasi asynchronous via **Azure Service Bus**, dan pembayaran melalui **Stripe**.

> Referensi belajar:
> - Introduction to .NET Microservices (.NET 8) — https://www.youtube.com/watch?v=Nw4AZs1kLAs
> - https://github.com/bhrugen/Mango_Microservices

## Daftar Isi

- [Arsitektur Sistem](#arsitektur-sistem)
- [Daftar Layanan](#daftar-layanan)
- [Pola Komunikasi](#pola-komunikasi)
- [Alur Registrasi & Login](#alur-registrasi--login)
- [Alur Keranjang Belanja & Email Cart](#alur-keranjang-belanja--email-cart)
- [Alur Checkout, Pembayaran, & Reward](#alur-checkout-pembayaran--reward)
- [Pemetaan Topic & Queue Service Bus](#pemetaan-topic--queue-service-bus)
- [Menjalankan Proyek](#menjalankan-proyek)

## Arsitektur Sistem

```mermaid
flowchart TB
    %% Layer 1: Client
    User((User)) ==>|"● 👉 Click"| Web["Mango.Web<br/><br/><br/>(MVC)"]

    %% Layer 2: Entry Points
    subgraph Entry ["Entry Points"]
        direction LR
        GW["API Gateway<br/><br/><br/>(Ocelot :7777)"]
        AuthEntry["AuthAPI<br/><br/><br/>:7002"]
    end

    Web ==>|"● 🌐 API Req"| GW
    Web ==>|"● 🔑 Auth Req"| AuthEntry

    %% Layer 3: Domain Services
    subgraph Domain ["Layanan Domain (Synchronous)"]
        direction LR
        Auth["AuthAPI<br/><br/><br/>:7002"]
        Coupon["CouponAPI<br/><br/><br/>:7001"]
        Product["ProductAPI<br/><br/><br/>:7000"]
        Cart["ShoppingCartAPI<br/><br/><br/>:7003"]
        Order["OrderAPI<br/><br/><br/>:7004"]
    end

    %% Connections from Entry Points to Domain
    AuthEntry --- Auth
    GW -->|"● 🎯 Route"| Product
    GW -->|"● 🎯 Route"| Coupon
    GW -->|"● 🎯 Route"| Cart
    GW -->|"● 🎯 Route"| Order
    
    %% Layer 4: Databases (Vertical Alignment)
    subgraph DBs ["Database Layer"]
        direction LR
        AuthDB[("Auth DB<br/><br/><br/>")]
        OrderDB[("Order DB<br/><br/><br/>")]
        CartDB[("Cart DB<br/><br/><br/>")]
        CouponDB[("Coupon DB<br/><br/><br/>")]
        ProductDB[("Product DB<br/><br/><br/>")]
    end

    Auth ---|"● 💾 Save"| AuthDB
    Coupon ---|"● 💾 Save"| CouponDB
    Product ---|"● 💾 Save"| ProductDB
    Cart ---|"● 💾 Save"| CartDB
    Order ---|"● 💾 Save"| OrderDB

    %% Side Logic: Async & External
    SB{{"Azure Service Bus<br/><br/><br/>"}}
    Stripe(["Stripe API<br/><br/><br/>"])

    Auth -- "● 🔔 Publish" --> SB
    Cart -- "● 🔔 Publish" --> SB
    Order -- "● 🔔 Publish" --> SB
    Order -->|"● 💳 Pay"| Stripe

    subgraph Async ["Background Services (Asynchronous)"]
        direction TB
        Email["EmailAPI<br/><br/><br/>:7299"]
        Reward["RewardAPI<br/><br/><br/>:7156"]
    end

    SB -->|"● 📩 Consume"| Email
    SB -->|"● 📩 Consume"| Reward
    
    Email ---|"● 💾 Log"| EmailDB[("Email Log DB<br/><br/><br/>")]
    Reward ---|"● 💾 Log"| RewardDB[("Reward DB<br/><br/><br/>")]

    %% Internal Dependencies
    Cart -.->|"● 🔍 Get"| Product
    Order -.->|"● 🔍 Get"| Product

    %% Styling
    style SB fill:#f9f,stroke:#333,stroke-width:2px
    style Stripe fill:#dfd,stroke:#333,stroke-width:2px
    style GW fill:#fff4dd,stroke:#d4a017,stroke-width:2px
    style Domain fill:#f5f5f5,stroke:#ccc,stroke-dasharray: 5 5
    style Async fill:#f5f5f5,stroke:#ccc,stroke-dasharray: 5 5
    style Entry fill:#fff,stroke:#ccc,stroke-dasharray: 5 5
```

### Keterangan Diagram Arsitektur

Untuk memudahkan pembacaan diagram di atas, berikut adalah penjelasan mengenai komponen visual yang digunakan:

#### 1. Penjelasan Layer (Lapisan)
Diagram disusun secara vertikal untuk menunjukkan aliran data dari atas ke bawah:
- **Client Layer (Atas)**: Titik awal interaksi pengguna melalui browser dan frontend `Mango.Web`.
- **Entry Point Layer**: Pintu masuk request ke sistem. `API Gateway` mengelola routing untuk sebagian besar layanan, sementara `AuthAPI` diakses langsung untuk proses autentikasi.
- **Domain Layer (Synchronous)**: Kumpulan microservices yang menangani logika bisnis utama dan merespons request secara langsung (real-time).
- **Database Layer (Bawah)**: Lapisan persistensi data di mana setiap layanan memiliki database terisolasi sendiri (Database-per-Service).
- **Async/Background Layer (Samping)**: Layanan yang bekerja secara asynchronous. Mereka tidak menunggu request dari user, melainkan bereaksi terhadap event yang masuk melalui `Azure Service Bus`.

#### 2. Penjelasan Jenis Garis & Marker (Edges)
Untuk menciptakan simetri visual (titik awal dan titik akhir), setiap garis menggunakan sistem marker berikut:
- **Titik Akhir**: Ditandai dengan **Panah** (simbol standar Mermaid) yang menunjukkan arah aliran data.
- **Titik Awal**: Ditandai dengan simbol **`●` (Black Circle)** pada label garis. Simbol ini berfungsi sebagai "titik start" untuk mengidentifikasi asal aksi:
    - **Garis Tebal (`==>`)**: Alur trafik utama.
        - `● 👉` (Click): Interaksi awal user.
        - `● 🌐` (API Req): Request menuju Gateway.
        - `● 🔑` (Auth Req): Request menuju AuthAPI.
    - **Garis Panah Standar (`-->`)**: Komunikasi **Synchronous HTTP**.
        - `● 🎯` (Route): Pengalihan traffic oleh Gateway ke layanan tujuan.
    - **Garis Putus-putus (`-.->`)**: Dependensi internal.
        - `● 🔍` (Get): Proses permintaan data antar-layanan.
    - **Garis Event (`-- "Event" -->`)**: Komunikasi **Asynchronous**.
        - `● 🔔` (Publish): Pengiriman event ke Message Broker.
        - `● 📩` (Consume): Penerimaan pesan oleh consumer.
    - **Garis Lurus Sederhana (`---`)**: Koneksi database.
        - `● 💾` (Save/Log): Proses persistensi data ke storage.

#### 3. Penjelasan Warna & Simbol
- **Warna Kuning (`GW`)**: Menandai komponen *Edge/Gateway* yang menjadi pengatur lalu lintas.
- **Warna Ungu (`SB`)**: Menandai *Message Broker* sebagai pusat distribusi event.
- **Warna Hijau (`Stripe`)**: Menandai integrasi dengan layanan pihak ketiga (External API).
- **Kotak Putus-putus**: Menandai pengelompokan logis layanan berdasarkan tipe komunikasinya (Sync vs Async).


Ciri arsitektur:
- **Mango.Web** adalah satu-satunya entry point untuk user (browser). Login/Register memanggil `AuthAPI` **langsung** (tidak lewat Gateway), sedangkan semua fitur lain (Product, Coupon, Cart, Order) melewati **API Gateway (Ocelot)**.
- **EmailAPI** dan **RewardAPI** tidak diakses langsung oleh Web/Gateway — keduanya murni **background message consumer** yang bereaksi terhadap event dari Service Bus.
- Komunikasi antar layanan domain (mis. Cart/Order memanggil Product) dilakukan secara **synchronous via HTTP**, sedangkan efek samping (kirim email, update reward) dilakukan secara **asynchronous via Azure Service Bus** agar layanan tidak saling blocking/coupling.

## Daftar Layanan

| Layanan | Port (HTTPS) | Tanggung Jawab | Autentikasi |
|---|---|---|---|
| `Mango.GatewaySolution` | 7777 | Reverse proxy (Ocelot) ke Product/Coupon/Cart/Order | - |
| `Mango.Services.AuthAPI` | 7002 | Register, Login, JWT, manajemen role (ASP.NET Identity) | Diakses langsung oleh Web |
| `Mango.Services.ProductAPI` | 7000 | CRUD Produk | Bearer (write only) |
| `Mango.Services.CouponAPI` | 7001 | CRUD Kupon diskon | Bearer (write only) |
| `Mango.Services.ShoppingCartAPI` | 7003 | Cart header/detail, apply coupon, request email cart | Bearer |
| `Mango.Services.OrderAPI` | 7004 | Buat order, integrasi Stripe, publish event pembayaran sukses | Bearer |
| `Mango.Services.EmailAPI` | 7299 | Consumer: kirim & log email (welcome, cart, konfirmasi order) | - (internal) |
| `Mango.Services.RewardAPI` | 7156 | Consumer: update poin reward user setelah order sukses | - (internal) |
| `Mango.Web` | - | Frontend MVC | Cookie + JWT ke API |

## Pola Komunikasi

| Pola | Digunakan Untuk | Teknologi |
|---|---|---|
| Synchronous request/response | Web ↔ Gateway ↔ Services, Cart/Order → Product | HTTP/HTTPS + `IHttpClientFactory` |
| Asynchronous pub/sub | Notifikasi email, update reward setelah order | Azure Service Bus (Queue & Topic/Subscription) |
| Payment redirect | Checkout pembayaran | Stripe Checkout Session |

## Alur Registrasi & Login

```mermaid
sequenceDiagram
    actor U as User
    participant W as Mango.Web
    participant A as AuthAPI
    participant SB as Azure Service Bus
    participant E as EmailAPI

    U->>W: Isi form Register
    W->>A: POST /api/auth/register (langsung, tanpa Gateway)
    A->>A: Buat user (ASP.NET Identity) + assign role default
    A->>SB: Publish email user ke queue "registeruser"
    A-->>W: 200 OK
    SB-->>E: Consume pesan queue "registeruser"
    E->>E: Simpan log & kirim welcome email

    U->>W: Isi form Login
    W->>A: POST /api/auth/login
    A->>A: Validasi kredensial & generate JWT
    A-->>W: JWT Token + Role
    W->>W: Simpan token (cookie/session)
    W-->>U: Redirect ke Home (Authenticated)
```

## Alur Keranjang Belanja & Email Cart

```mermaid
sequenceDiagram
    actor U as User
    participant W as Mango.Web
    participant GW as API Gateway
    participant C as ShoppingCartAPI
    participant P as ProductAPI
    participant SB as Azure Service Bus
    participant E as EmailAPI

    U->>W: Klik "Add to Cart"
    W->>GW: POST /api/cart/CartUpsert (Bearer Token)
    GW->>C: Forward request
    C->>P: GET produk terkait (sync HTTP)
    C->>C: Upsert CartHeader/CartDetails
    C-->>GW: 200 OK
    GW-->>W: Response

    U->>W: Terapkan kode kupon di halaman Cart
    W->>GW: POST /api/cart/ApplyCoupon
    GW->>C: Forward
    C-->>GW: 200 OK
    GW-->>W: Cart ter-update dengan diskon

    U->>W: Klik "Email Cart"
    W->>GW: POST /api/cart/EmailCartRequest
    GW->>C: Forward
    C->>SB: Publish CartDto ke queue "emailshoppingcart"
    C-->>GW: 200 OK
    GW-->>W: Response
    SB-->>E: Consume pesan queue "emailshoppingcart"
    E->>E: Render & kirim email isi keranjang, simpan log
```

## Alur Checkout, Pembayaran, & Reward

```mermaid
sequenceDiagram
    actor U as User
    participant W as Mango.Web
    participant GW as API Gateway
    participant O as OrderAPI
    participant St as Stripe
    participant SB as Azure Service Bus
    participant E as EmailAPI
    participant R as RewardAPI

    U->>W: Klik "Checkout" dari halaman Cart
    W->>GW: POST /api/order/CreateOrder (CartDto)
    GW->>O: Forward
    O->>O: Simpan OrderHeader (Status = Pending) + OrderDetails
    O-->>GW: OrderHeaderDto
    GW-->>W: OrderHeaderDto

    W->>GW: POST /api/order/CreateStripeSession
    GW->>O: Forward
    O->>St: Buat Checkout Session (line items + diskon kupon)
    St-->>O: Session URL
    O->>O: Update OrderHeader.StripeSessionId
    O-->>GW: StripeSessionUrl
    GW-->>W: StripeSessionUrl
    W-->>U: Redirect ke halaman pembayaran Stripe

    U->>St: Input kartu & konfirmasi bayar
    St-->>U: Redirect ke ApprovedUrl (halaman konfirmasi Web)

    W->>GW: POST /api/order/ValidateStripeSession (orderHeaderId)
    GW->>O: Forward
    O->>St: Get Session & PaymentIntent
    St-->>O: PaymentIntent.Status = "succeeded"

    alt Pembayaran sukses
        O->>O: Update Status = Approved, simpan PaymentIntentId
        O->>SB: Publish RewardsDto ke topic "OrderCreated"
        O-->>GW: OrderHeaderDto (Approved)
        GW-->>W: Response
        W-->>U: Tampilkan halaman konfirmasi order

        SB-->>E: Consume via subscription "OrderCreatedEmail"
        E->>E: Kirim & log email konfirmasi order

        SB-->>R: Consume via subscription "OrderCreatedRewardsUpdate"
        R->>R: Tambahkan RewardsActivity ke akun user
    else Pembayaran gagal/pending
        O-->>GW: Response tanpa perubahan status
        GW-->>W: Response
        W-->>U: Tampilkan status pembayaran belum berhasil
    end
```

## Pemetaan Topic & Queue Service Bus

| Nama Topic/Queue | Tipe | Publisher | Subscriber | Payload |
|---|---|---|---|---|
| `registeruser` | Queue | AuthAPI | EmailAPI | `string` (email) |
| `emailshoppingcart` | Queue | ShoppingCartAPI | EmailAPI | `CartDto` |
| `OrderCreated` (subscription `OrderCreatedEmail`) | Topic | OrderAPI | EmailAPI | `RewardsDto` |
| `OrderCreated` (subscription `OrderCreatedRewardsUpdate`) | Topic | OrderAPI | RewardAPI | `RewardsDto` |

Satu event `OrderCreated` di-broadcast ke **dua subscriber berbeda** (fan-out) sehingga EmailAPI dan RewardAPI dapat memproses pesan yang sama secara independen tanpa saling mengetahui satu sama lain.

## Menjalankan Proyek

### Build

```bash
dotnet build Mango.sln
```

### Jalankan (Run)

Lihat skill `run` untuk instruksi detail: `/run` (atau cek `.claude/skills/run.md`).

## Panduan Coding

- Ikuti standar idiom .NET 8.
- Gunakan Dependency Injection untuk service dan repository.
- Jaga pemisahan tanggung jawab (Separation of Concerns) antara lapisan API dan lapisan Domain.
- Untuk setiap layanan baru, pastikan telah ditambahkan ke `Mango.sln` dan dikonfigurasi di `Mango.GatewaySolution` (`ocelot.json`).

## Database

Sebagian besar layanan menggunakan Entity Framework Core. Periksa folder `Data` di setiap layanan untuk menemukan `AppDbContext`.
