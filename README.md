#Tic Tac (XO)

โจทย์
1. ให้เขียนเกม XO ด้วย Web หรือ Mobile App โดยให้เกมสามารถกำหนด ขนาดตารางของ XO นอกจาก 3x3 เป็นขนาดใด ๆ ก็ได้

2. มีระบบฐานข้อมูลเก็บ history play ของเกมเพื่อดู replay ได้

3. ส่งโค้ดกลับมาผ่าน github public link พร้อม readme วิธีการ setup, run โปรแกรม, วิธีออกแบบโปรแกรมและ algorithm ที่ใช้

4. หลังจากทำ 1-3 เสร็จ กรอกฟอร์มข้อมูลใบสมัครเพื่อประกอบผลทดสอบตามลิงค์นี้ https://forms.gle/LTTUQb76PMnAUYJA7

โจทย์ bonus point มี AI ระบบ bot คู่ต่อสู้ ที่เล่นกับมนุษย์อัตโนมัติได้ [โจทย์นี้เป็น optional ทำหรือไม่ทำก็ได้]

**ทำโจทย์แล้วส่งกลับมาที่ E-mail นี้ได้เลยค่ะ**  ระยะเวลาทำโจทย์ภายใน 7 วัน หลังจากได้รับ Email นี้

## Setup
* ตรวจสอบการติดตั้งของ Flutter ภายในเครื่อง
* ตรวจสอบการทำงานของอุปกรณ์ หรือ Emulator
 
 # RunApp
 * Run บนอุปกรณ์ หรือ Emulator

 ## การออกเเบบโปรเเกรม
 * Minimax algorithm  เป็นส่วนใช้ทำ bot หรือ Ai
 * Database ใช้ Sqflite ใน Flutter สำหรับเก็บประวัติการเล่น

# ผู้เล่น
* ผู้เล่น X , O
* ฝั่ง bot หรือ Ai  จะเป็นส่วนของผู้เล่น O

# การเล่น
* ถ้าเล่น2คน เลือก X,O ได้ปกติเเต่จะเรื่ม Turn X ตาเเรกเสมอ
* ถ้าเล่นกับ Bot ผู้เล่นสามารถกด Play a bot ลง O ก่อน หรือ ผู้เล่นเลือกลง X ก่อนได้  สำหรับ Play a bot ต้องกดปุ่มตลอดเวลาเพื่อใช้สำหรับเพิ่ม O ลงในตาราง เเละจะสลับ Turn ไปเรื่อยๆ

# Database
* จะเก็บผู้ชนะเเละเสมอ เช่น Winner Player O or X win 
                         Date xxxx-x-xx, Time xx:xx
                         Winner Draw 
                         Date xxxx-x-xx, Time xx:xx

# หลักการทำงาน
* ขั้นตอนวิธี minimax คือขั้นตอนวิธีการตัดสินใจหลีกเลี่ยงโอกาสที่จะทำให้เกิดความสูญเสียมากที่สุดในการเล่นเกมเชิงตรรกะที่มีผู้เล่นสองคนโดยเฉพาะยิ่งทางด้านปัญาประดิษฐ์ที่อยู่
ในเกมต่างๆ ที่นิยมคือ XO หมากฮอส

## ปัญหาที่พบ
* ไม่สามารถขยายตารางได้
* สามารถเก็บข้อมูลย้อนหลังได้เเต่ยังมีบัคบางส่วน
* Play a bot กดได้เรื่อยๆโดยไม่ต้องรอ Turn X