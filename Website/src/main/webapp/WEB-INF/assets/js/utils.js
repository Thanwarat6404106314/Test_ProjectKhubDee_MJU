function convertToBuddhistYear() {
        const dateInput = document.getElementById('news-date').value;
        if (dateInput) {
            const date = new Date(dateInput);
            const day = date.getDate();
            const month = date.getMonth() + 1; // เดือนเริ่มจาก 0
            const year = date.getFullYear() + 543; // แปลงปี ค.ศ. เป็น พ.ศ.

            // แสดงวันที่ในรูปแบบ วัน/เดือน/ปี พ.ศ.
            document.getElementById('output').innerText = `วันที่เลือก: ${day}/${month}/${year} (พ.ศ.)`;
        }
}