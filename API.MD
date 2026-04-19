## BASE URL

https://story-api.dicoding.dev/v1

## ENDPOINTS

### 1. Register
**POST** `/register`

Mendaftarkan akun pengguna baru.

**Request Body (JSON):**
- `name`: string
- `email`: string (unik)
- `password`: string (minimal 8 karakter)

**Response:**
```json
{
  "error": false,
  "message": "User Created"
}
```

---

### 2. Login
**POST** `/login`

Masuk ke dalam aplikasi untuk mendapatkan token autentikasi.

**Request Body (JSON):**
- `email`: string
- `password`: string

**Response:**
```json
{
  "error": false,
  "message": "success",
  "loginResult": {
    "userId": "string",
    "name": "string",
    "token": "string"
  }
}
```

---

### 3. Get All Stories
**GET** `/stories`

Mendapatkan daftar cerita. Memerlukan Header `Authorization: Bearer <token>`.

**Query Parameters (Optional):**
- `page`: integer (halaman data)
- `size`: integer (jumlah data per halaman)
- `location`: integer (1 untuk menyertakan lokasi, 0 jika tidak)

**Response:**
```json
{
  "error": false,
  "message": "Stories fetched successfully",
  "listStory": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "photoUrl": "string",
      "createdAt": "string",
      "lat": "float",
      "lon": "float"
    }
  ]
}
```

---

### 4. Get Detail Story
**GET** `/stories/{id}`

Mendapatkan detail dari sebuah cerita berdasarkan ID. Memerlukan Header `Authorization: Bearer <token>`.

**Response:**
```json
{
  "error": false,
  "message": "Story fetched successfully",
  "story": {
    "id": "string",
    "name": "string",
    "description": "string",
    "photoUrl": "string",
    "createdAt": "string",
    "lat": "float",
    "lon": "float"
  }
}
```

---

### 5. Add New Story
**POST** `/stories`

Menambahkan cerita baru. Memerlukan Header `Authorization: Bearer <token>` dan `Content-Type: multipart/form-data`.

**Request Body (Multipart Form Data):**
- `description`: string
- `photo`: file (gambar, maks 1MB)
- `lat`: float (opsional)
- `lon`: float (opsional)

**Response:**
```json
{
  "error": false,
  "message": "success"
}
```

---

### 6. Add New Story (Guest)
**POST** `/stories/guest`

Menambahkan cerita baru tanpa perlu login (akun guest). Menggunakan `Content-Type: multipart/form-data`.

**Request Body (Multipart Form Data):**
- `description`: string
- `photo`: file (gambar, maks 1MB)
- `lat`: float (opsional)
- `lon`: float (opsional)

**Response:**
```json
{
  "error": false,
  "message": "success"
}
```

---

### 7. Web Push - Subscribe
**POST** `/notifications/subscribe`

Mendaftarkan push notification. Memerlukan Header `Authorization: Bearer <token>`.

**Request Body (JSON):**
- `endpoint`: string
- `keys`: object (`p256dh`: string, `auth`: string)

**Response:**
```json
{
  "error": false,
  "message": "Success to subscribe web push notification.",
  "data": {
    "id": "string",
    "endpoint": "string",
    "keys": { "p256dh": "string", "auth": "string" },
    "userId": "string",
    "createdAt": "string"
  }
}
```

---

### 8. Web Push - Unsubscribe
**DELETE** `/notifications/subscribe`

Menghapus push notification. Memerlukan Header `Authorization: Bearer <token>`.

**Request Body (JSON):**
- `endpoint`: string

**Response:**
```json
{
  "error": false,
  "message": "Success to unsubscribe web push notification."
}
```

**Additional Info:**
- VAPID Public Key: `BCCs2eonMI-6H2ctvFaWg-UYdDv387Vno_bzUzALpB442r2lCnsHmtrx8iyPi_E-1fSGABK_Qs_G1vPoJJqxbk`