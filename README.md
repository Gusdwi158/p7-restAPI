# Course Data Manager (Course Explorer v2)

Aplikasi mobile Flutter untuk manajemen data mata kuliah (*Course*) dengan integrasi REST API dan Backend Database Supabase.

## Identitas Mahasiswa
- **Nama:** I Kadek Agus Dwi Adnyana[cite: 2]
- **NIM:** 2415051076[cite: 2]
- **Kelas:** PTI 5 A[cite: 2]

---

## Dokumentasi REST Endpoint & Struktur JSON (Tahap 1)

### 1. Informasi Endpoint Latihan
- **Base URL (`apiBaseUrl`):** `https://course-api-pearl.vercel.app`[cite: 6]
- **Endpoint GET:** `https://course-api-pearl.vercel.app/courses`[cite: 6]
- **HTTP Method:** `GET`[cite: 6]
- **Status Code:** `200 OK`
- **Resource:** `courses`[cite: 6]

### 2. Contoh Response Body (JSON)
```json
[
  {
    "id": 1,
    "code": "MOB01",
    "title": "Git & GitHub",
    "credits": 2,
    "status": "active"
  }
]