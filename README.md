# 📱 **Booking Meja — Release Notes**
## 🚀 **v0.4 — Persistence & Smart Booking Update**

![Version](https://img.shields.io/badge/version-v0.4-red?style=for-the-badge)
![Status](https://img.shields.io/badge/status-pre--alpha-yellow?style=for-the-badge)
![Platform](https://img.shields.io/badge/flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Build](https://img.shields.io/badge/build-apk-orange?style=for-the-badge)

### 🔧 **What's Changed**
- Penyimpanan data booking permanen menggunakan `shared_preferences`.
- Data booking tetap tersimpan meskipun aplikasi ditutup.
- Sistem booking mencegah bentrok jam pada meja yang sama.
- Durasi booking dibatasi antara 1 hingga 3 jam.
- Sistem pemilihan jam booking tidak mengizinkan pemilihan waktu yang sudah lewat.
- Validasi input pengguna untuk nama dan nomor HP.
- Bahasa aplikasi diubah sepenuhnya ke Bahasa Indonesia.
- Sinkronisasi otomatis status dan warna meja berdasarkan data booking.

### 🛠 **Technical Improvements**
- Perbaikan bug perubahan status meja setelah pembayaran berhasil.
- Perbaikan logika perhitungan antrian agar spesifik per meja.
- Optimasi penyimpanan dan pemanggilan data booking.
- Peningkatan stabilitas aplikasi secara keseluruhan.

### 👥 **Authors**
- **Rafi**  
- **Fajrin**  
- **Ariel**  
- **Afdal**

📊 [Lihat Slide Presentasi (PDF)](https://drive.google.com/file/d/1JD1XX1V8Z1AoX0We50Ian4pKfSiYq1Ul/view?usp=sharing)

### 📜 **Full Changelog**
https://github.com/Kiano-Ksl/Tugas_Aplikasi_booking_meja/compare/Pre_Alpha_apk3...Pre_Alpha_apk4



## 🚀 **v0.3 — UI Update & Booking History Cleanup**

![Version](https://img.shields.io/badge/version-v0.3-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/status-pre--alpha-yellow?style=for-the-badge)
![Platform](https://img.shields.io/badge/flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Build](https://img.shields.io/badge/build-apk-orange?style=for-the-badge)

### 🔧 **What's Changed**
- Penambahan **ikon aplikasi custom**, menggantikan ikon default Flutter.  
- Penambahan fitur **hapus riwayat tiket booking** jika status sudah *Completed*.  
- Penyempurnaan UI agar lebih konsisten dan profesional.

### 🛠 **Technical Improvements**
- Pembersihan asset lama & penyesuaian struktur untuk ikon baru.  
- Perbaikan minor untuk stabilitas halaman booking dan history.

### 📜 **Full Changelog**
https://github.com/Kiano-Ksl/Tugas_Aplikasi_booking_meja/compare/Pre_Alpha_apk...Pre_Alpha_apk3



## 🚀 **v0.2 — Pre-Alpha Update**

![Version](https://img.shields.io/badge/version-v0.2-purple?style=for-the-badge)
![Status](https://img.shields.io/badge/status-pre--alpha-yellow?style=for-the-badge)
![Platform](https://img.shields.io/badge/flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Build](https://img.shields.io/badge/build-split--apk-orange?style=for-the-badge)

### 🔧 **What's Changed**
- Peningkatan tampilan UI & UX  
- Penataan ulang struktur folder proyek  
- Perbaikan performa saat membuka halaman  
- Optimisasi navigasi  
- Build apk menggunakan `--split-per-abi` (armeabi-v7a, arm64-v8a, x86_64)

### 🛠 **Technical Improvements**
- Refactor beberapa komponen untuk modularitas  
- Perbaikan bug minor  

### 📜 **Full Changelog**
https://github.com/Kiano-Ksl/Tugas_Aplikasi_booking_meja/commits/Pre_Alpha_apk2



## 🚀 **v0.1 — Initial Release**

![Version](https://img.shields.io/badge/version-v0.1-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/status-initial_release-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Build](https://img.shields.io/badge/build-apk-orange?style=for-the-badge)

### 🌟 **Overview**
Rilis awal dari aplikasi **Booking Meja**, versi pertama yang menyediakan fitur dasar untuk melakukan pemesanan meja di sebuah kafe.

### ✨ **Features**
- UI dasar yang responsif  
- Registrasi dan login  
- Melihat daftar meja  
- Melakukan booking meja  
- Halaman home dan navigasi dasar

### 📜 **Full Changelog**
https://github.com/R4ff-27/booking_meja/commits/demo_apk



