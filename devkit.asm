[org 0x0]
[bits 32]

; --- LNC v2 Başlığı ---
db 0x4C, 0x4E, 0x43
db 0x02
dd devkit_basla - $$

devkit_basla:
    ; Tampon temizle
    mov ecx, 64
    mov edi, ebp
    add edi, komut_tamponu
.tampon_temizle:
    mov byte [edi], 0
    inc edi
    loop .tampon_temizle

    mov dword [ebp + tampon_indeksi], 0

    ; Ekranı temizle
    mov eax, [edx + 4]
    call eax

    ; --- GENERIC LEGACY BIOS POST EKRANI ---
    mov ebx, 0xB8000         ; Ekranın en başından başla
    mov ecx, [edx]           ; Sistem yazdırma fonksiyonunu ecx'e al

    ; Satır 0: BIOS Başlığı (Anonimleştirildi)
    mov edi, ebx
    mov esi, ebp
    add esi, bios_s1
    mov ah, 0x0F            ; Parlak Beyaz
    call ecx
    call yeni_satira_gec

    ; Satır 1: Telif Bilgisi (Z.eSystem)
    mov edi, ebx
    mov esi, ebp
    add esi, bios_s2
    mov ah, 0x07            ; Standart Gri
    call ecx
    call yeni_satira_gec

    ; Satır 2: CPU Bilgisi
    mov edi, ebx
    mov esi, ebp
    add esi, bios_s3
    mov ah, 0x07            ; Standart Gri
    call ecx
    call yeni_satira_gec

    ; Satır 3: RAM Testi
    mov edi, ebx
    mov esi, ebp
    add esi, bios_s4
    mov ah, 0x0A            ; Parlak Yeşil
    call ecx
    call yeni_satira_gec

    ; Satır 4: Depolama / SSD Algılama (Anonimleştirildi)
    mov edi, ebx
    mov esi, ebp
    add esi, bios_s5
    mov ah, 0x07            ; Standart Gri
    call ecx
    call yeni_satira_gec

    ; Satır 5: MBR Boot Başarılı
    mov edi, ebx
    mov esi, ebp
    add esi, bios_s6
    mov ah, 0x0E            ; Parlak Sarı
    call ecx
    call yeni_satira_gec
    call yeni_satira_gec    ; Bir satır boşluk

    ; --- KERNEL TERMİNAL BAŞLIĞI ---
    mov edi, ebx
    mov esi, ebp
    add esi, dev_baslik
    mov ah, 0x0B            ; Açık Mavi / Turkuaz
    call ecx
    call yeni_satira_gec

    ; Yardım İpucu
    mov edi, ebx
    mov esi, ebp
    add esi, yardim_ipucu
    mov ah, 0x07            ; Standart gri renk
    call ecx

    ; İlk prompt için bir alt satıra geç
    call yeni_satira_gec
    call print_prompt

.komut_dongusu:
    mov ecx, [edx + 12]
.tus_bekle:
    mov al, [ecx]
    cmp al, 0
    je .tus_bekle

    mov byte [ecx], 0

    cmp al, 0x01
    je .dev_cikis
    cmp al, 0x1C
    je .komut_isle
    cmp al, 0x0E            ; Backspace scancode'u yakala
    je .backspace_isle      ; Silme alt programına git

    call klavye_ascii_cevir
    or al, al
    jz .komut_dongusu

    mov esi, [ebp + tampon_indeksi]
    cmp esi, 60
    jge .komut_dongusu

    mov [ebp + komut_tamponu + esi], al
    inc dword [ebp + tampon_indeksi]

    mov [ebx], al
    mov [ebx + 1], byte 0x0F
    add ebx, 2
    jmp .komut_dongusu

.backspace_isle:
    mov esi, [ebp + tampon_indeksi]
    cmp esi, 0
    je .komut_dongusu       ; Koruma

    dec dword [ebp + tampon_indeksi]
    dec esi
    mov byte [ebp + komut_tamponu + esi], 0

    sub ebx, 2              ; Ekranda geriye git
    mov byte [ebx], ' '     ; Karakteri görsel olarak sil
    mov byte [ebx + 1], 0x0F
    jmp .komut_dongusu

.komut_isle:
    call yeni_satira_gec     ; Bir alt satıra geç
    call komut_yorumlayici
    jmp konsolu_sifirla

.dev_cikis:
    ret

; ====================== KOMUT YORUMLAYICI ======================
komut_yorumlayici:
    ; YARDIM
    cmp byte [ebp + komut_tamponu], 'Y'
    jne .yaz_kontrol
    cmp byte [ebp + komut_tamponu+1], 'A'
    jne .yaz_kontrol
    cmp byte [ebp + komut_tamponu+2], 'R'
    jne .yaz_kontrol
    cmp byte [ebp + komut_tamponu+3], 'D'
    jne .yaz_kontrol
    cmp byte [ebp + komut_tamponu+4], 'I'
    jne .yaz_kontrol
    cmp byte [ebp + komut_tamponu+5], 'M'
    jne .yaz_kontrol
    call komut_yardim
    ret

.yaz_kontrol:
    cmp byte [ebp + komut_tamponu], 'Y'
    jne .temizle_kontrol
    cmp byte [ebp + komut_tamponu+1], 'A'
    jne .temizle_kontrol
    cmp byte [ebp + komut_tamponu+2], 'Z'
    jne .temizle_kontrol
    cmp byte [ebp + komut_tamponu+3], ' '
    jne .temizle_kontrol
    call komut_yaz
    ret

.temizle_kontrol:
    cmp byte [ebp + komut_tamponu], 'T'
    jne .cikis_kontrol       
    cmp byte [ebp + komut_tamponu+1], 'E'
    jne .cikis_kontrol
    cmp byte [ebp + komut_tamponu+2], 'M'
    jne .cikis_kontrol
    cmp byte [ebp + komut_tamponu+3], 'I'
    jne .cikis_kontrol
    cmp byte [ebp + komut_tamponu+4], 'Z'
    jne .cikis_kontrol
    cmp byte [ebp + komut_tamponu+5], 'L'
    jne .cikis_kontrol
    cmp byte [ebp + komut_tamponu+6], 'E'
    jne .cikis_kontrol
    
    mov eax, [edx + 4]       ; Ekranı temizle
    call eax
    
    ; Başlığı yeniden yazdır
    mov edi, 0xB8000
    mov esi, ebp
    add esi, dev_baslik
    mov ah, 0x0B
    mov ecx, [edx]
    call ecx
    
    ; İpucunu yeniden yazdır
    mov ebx, 0xB8000
    call yeni_satira_gec
    mov edi, ebx
    mov esi, ebp
    add esi, yardim_ipucu
    mov ah, 0x07
    mov ecx, [edx]
    call ecx
    ret

.cikis_kontrol:
    cmp byte [ebp + komut_tamponu], 'C'
    je .cikis_yap
    cmp byte [ebp + komut_tamponu], 'E'
    je .cikis_yap
    cmp byte [ebp + komut_tamponu], 'X'
    je .cikis_yap

    ; Bilinmeyen komut
    mov edi, ebx
    mov esi, ebp
    add esi, hata_mesaj
    mov ah, 0x0C
    mov ecx, [edx]
    call ecx
    ret

.cikis_yap:
    jmp devkit_basla.dev_cikis

; ====================== KOMUT FONKSİYONLARI ======================
komut_yaz:
    mov edi, ebx
    mov esi, ebp
    add esi, komut_tamponu + 4
    mov ah, 0x0A
    mov ecx, [edx]
    call ecx
    ret

komut_yardim:
    mov ecx, [edx]
    
    mov edi, ebx
    mov esi, ebp
    add esi, yardim_s1
    mov ah, 0x0B
    call ecx
    call yeni_satira_gec

    mov edi, ebx
    mov esi, ebp
    add esi, yardim_s2
    mov ah, 0x0B
    call ecx
    call yeni_satira_gec

    mov edi, ebx
    mov esi, ebp
    add esi, yardim_s3
    mov ah, 0x0B
    call ecx
    call yeni_satira_gec

    mov edi, ebx
    mov esi, ebp
    add esi, yardim_s4
    mov ah, 0x0B
    call ecx
    call yeni_satira_gec

    mov edi, ebx
    mov esi, ebp
    add esi, yardim_s5
    mov ah, 0x0B
    call ecx
    ret

konsolu_sifirla:
    mov dword [ebp + tampon_indeksi], 0
    mov ecx, 64
    mov edi, ebp
    add edi, komut_tamponu
.tur_temizle:
    mov byte [edi], 0
    inc edi
    loop .tur_temizle

    call yeni_satira_gec
    call print_prompt
    jmp devkit_basla.komut_dongusu

print_prompt:
    mov edi, ebx
    mov esi, ebp
    add esi, prompt
    mov ecx, [edx]
    call ecx
    add ebx, 4
    ret

; ====================== MODERN TERMİNAL MOTORU ======================
yeni_satira_gec:
    push eax
    push ecx
    push edx
    
    sub ebx, 0xB8000
    mov eax, ebx
    xor edx, edx
    mov ecx, 160
    div ecx
    inc eax
    mul ecx
    add eax, 0xB8000
    
    cmp eax, 0xB8FA0
    jb .sinir_ici
    mov eax, 0xB80A0
.sinir_ici:
    mov ebx, eax
    
    pop edx
    pop ecx
    pop eax
    ret

; ====================== KLAVYE ÇEVİRİCİ ======================
klavye_ascii_cevir:
    cmp al, 0x80
    jae .bos
    cmp al, 0x01
    je .esc
    cmp al, 0x0E
    je .backspace
    cmp al, 0x1C
    je .enter
    cmp al, 0x39
    je .space
    cmp al, 0x02
    jb .harfler
    cmp al, 0x0B
    ja .harfler
    add al, '1' - 0x02
    ret
.harfler:
    cmp al, 0x10
    je .q
    cmp al, 0x11
    je .w
    cmp al, 0x12
    je .e
    cmp al, 0x13
    je .r
    cmp al, 0x14
    je .t
    cmp al, 0x15
    je .y
    cmp al, 0x16
    je .u
    cmp al, 0x17
    je .i
    cmp al, 0x18
    je .o
    cmp al, 0x19
    je .p
    cmp al, 0x1E
    je .a
    cmp al, 0x1F
    je .s
    cmp al, 0x20
    je .d
    cmp al, 0x21
    je .f
    cmp al, 0x22
    je .g
    cmp al, 0x23
    je .h
    cmp al, 0x24
    je .j
    cmp al, 0x25
    je .k
    cmp al, 0x26
    je .l
    cmp al, 0x2C
    je .z
    cmp al, 0x2D
    je .x
    cmp al, 0x2E
    je .c
    cmp al, 0x2F
    je .v
    cmp al, 0x30
    je .b
    cmp al, 0x31
    je .n
    cmp al, 0x32
    je .m
.bos:
    xor al, al
    ret
.esc:       mov al, 27
            ret
.backspace: mov al, 8
            ret
.enter:     mov al, 10
            ret
.space:     mov al, ' '
            ret
.q:         mov al, 'Q'
            ret
.w:         mov al, 'W'
            ret
.e:         mov al, 'E'
            ret
.r:         mov al, 'R'
            ret
.t:         mov al, 'T'
            ret
.y:         mov al, 'Y'
            ret
.u:         mov al, 'U'
            ret
.i:         mov al, 'I'
            ret
.o:         mov al, 'O'
            ret
.p:         mov al, 'P'
            ret
.a:         mov al, 'A'
            ret
.s:         mov al, 'S'
            ret
.d:         mov al, 'D'
            ret
.f:         mov al, 'F'
            ret
.g:         mov al, 'G'
            ret
.h:         mov al, 'H'
            ret
.j:         mov al, 'J'
            ret
.k:         mov al, 'K'
            ret
.l:         mov al, 'L'
            ret
.z:         mov al, 'Z'
            ret
.x:         mov al, 'X'
            ret
.c:         mov al, 'C'
            ret
.v:         mov al, 'V'
            ret
.b:         mov al, 'B'
            ret
.n:         mov al, 'N'
            ret
.m:         mov al, 'M'
            ret

; ====================== MESAJLAR ======================
; --- BIOS POST Metinleri (Şirket İsimleri Kaldırıldı) ---
bios_s1:        db "Standard Legacy BIOS v2.56", 0
bios_s2:        db "Copyright (C) 2024-2026 Z.eSystem. MIT Licensed.", 0
bios_s3:        db "CPU: x86 Protected Mode Core - Running at Max Speed", 0
bios_s4:        db "RAM TEST: 640KB Base / 4096MB Extended -> OK", 0
bios_s5:        db "STORAGE: Scanning Ports... [SSD-0: MainDrive] DETECTED", 0
bios_s6:        db "Booting from MBR Sector... Z.eSystem Kernel Loaded!", 0

; --- Terminal Metinleri ---
dev_baslik:     db "=== Z.eSystem Developer Tool Suite v1.4 ===", 0
yardim_ipucu:   db "Yardim almak icin YARDIM yazin.", 0
prompt:         db "> ", 0
hata_mesaj:     db "[Hata]: Gecersiz komut!", 0

yardim_s1:      db "Kullanilabilir Komutlar:", 0
yardim_s2:      db "  YAZ <metin>     -> Metin yazdirir", 0
yardim_s3:      db "  TEMIZLE         -> Ekrani temizler", 0
yardim_s4:      db "  YARDIM          -> Bu yardimi gosterir", 0
yardim_s5:      db "  CIKIS / EXIT    -> Devkit'ten cikar", 0

align 4
tampon_indeksi: dd 0
komut_tamponu:  times 64 db 0

times 4608-($-$$) db 0