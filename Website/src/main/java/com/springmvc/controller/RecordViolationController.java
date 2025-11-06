package com.springmvc.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.springmvc.manager.*;
import com.springmvc.model.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class RecordViolationController {
	
//	Record Violation Page
	@RequestMapping(value = "/list-violation", method = RequestMethod.GET)
	public ModelAndView recordViolationPage(HttpServletRequest request, HttpSession session) {
	    int page = 1; 
	    int size = 10; 

	    String pageParam = request.getParameter("page");
	    if (pageParam != null && !pageParam.isEmpty()) {
	        page = Integer.parseInt(pageParam);
	    }

	    String sizeParam = request.getParameter("size");
	    if (sizeParam != null && !sizeParam.isEmpty()) {
	        size = Integer.parseInt(sizeParam);
	    }

	    RecordViolationManager rvm = new RecordViolationManager();
	    
	    List<RecordViolation> ListRV = rvm.getListRV(page, size);
	    long totalRecords = rvm.getTotalRVPending(); 
	    long totalPages = (long) Math.ceil((double) totalRecords / size);

	    ModelAndView mav = new ModelAndView("list_violation");
	    mav.addObject("ListRecordViolation", ListRV);
	    mav.addObject("currentPage", page);
	    mav.addObject("totalPages", totalPages);
	    mav.addObject("pageSize", size);
	    mav.addObject("totalRecords", totalRecords);

	    return mav;
	}
	
	// ค้นหา
	@RequestMapping(value = "/search", method = RequestMethod.GET)
	public ModelAndView searchRecordViolation(
	        @RequestParam(value = "searchText", required = false) String searchText,
	        @RequestParam(value = "startDate", required = false) String startDate,
	        @RequestParam(value = "page", required = false, defaultValue = "1") int page,
	        @RequestParam(value = "size", required = false, defaultValue = "10") int size) {

	    ModelAndView mav = new ModelAndView("list_violation");
	    RecordViolationManager rvm = new RecordViolationManager();

	    if ((searchText == null || searchText.trim().isEmpty()) && (startDate == null || startDate.isEmpty())) {
	        mav.addObject("message", "กรุณากรอกข้อมูลในการค้นหา");
	        return mav;
	    }

	    List<RecordViolation> ListRV = rvm.getSearchRecordViolation(searchText, startDate, page, size);

	    if (ListRV == null || ListRV.isEmpty()) {
	        mav.addObject("message", "ไม่พบข้อมูล");
	    } else {
	        long totalRecords = rvm.getTotalSearchRV(searchText, startDate);
	        long totalPages = (long) Math.ceil((double) totalRecords / size);

	        mav.addObject("ListRecordViolation", ListRV);
	        mav.addObject("currentPage", page);
	        mav.addObject("totalPages", totalPages);
	        mav.addObject("pageSize", size);
	        mav.addObject("totalRecords", totalRecords);
	        mav.addObject("searchQuery", searchText);
	        mav.addObject("startQuery", startDate);
	    }

	    return mav;
	}

	// อัพเดตสถานะและหักคะแนน
	@RequestMapping(value = "/update-statustype", method = RequestMethod.POST)
	public ModelAndView updateRVStatusType(HttpServletRequest request, HttpSession session) throws ParseException {
	    Officer officer = (Officer) session.getAttribute("officer");
	    if (officer == null) {
	        ModelAndView mav = new ModelAndView("signin");
	        mav.addObject("errorMessage", "กรุณาเข้าสู่ระบบก่อนทำรายการ");
	        return mav;
	    }
	    String officer_id = officer.getOfficer_id();

	    String record_id = request.getParameter("record-id");
	    String status_type = request.getParameter("status-type");
	    Date deduct_date = new Date();

	    RecordViolationManager rvm = new RecordViolationManager();
	    boolean result = rvm.updateRVStatusType(record_id, status_type, deduct_date, officer_id);

	    int page = Integer.parseInt(request.getParameter("page"));
	    int size = Integer.parseInt(request.getParameter("size"));
	    String redirectUrl = String.format("/list-violation?page=%d&size=%d", page, size);
	    RedirectView redirectView = new RedirectView(redirectUrl, true);
	    ModelAndView mav = new ModelAndView(redirectView);

	    if (result) {
	        mav.addObject("success", "อัปเดตสถานะสำเร็จ");
	    } else {
	        mav.addObject("error", "การอัปเดตสถานะล้มเหลว");
	    }
	    return mav;
	}

	
//	Record Violation Detail Page
	@RequestMapping(value="/view-violation", method=RequestMethod.GET)
	public ModelAndView recordViolationDetailPage(HttpServletRequest request) {
		
	    String record_id = request.getParameter("record_id");
	    
	    RecordViolationManager rvm = new RecordViolationManager();
	    RecordViolation rec = rvm.getRecordViolationByID(record_id);

	    ModelAndView mav = new ModelAndView("view_violation");
	    mav.addObject("RV", rec);
	    return mav;
	}
	
	// export excel
	@RequestMapping(value="/export-excel-violation", method = RequestMethod.GET)
	public ModelAndView exportViolationExcel(HttpServletRequest request, HttpServletResponse response) {
	    try {
	        RecordViolationManager rvm = new RecordViolationManager();
	        List<RecordViolation> pendingRV = rvm.getListRVByStatus("กำลังพิจารณา");

	        // สร้าง Excel File โดยใช้ Apache POI
	        XSSFWorkbook workbook = new XSSFWorkbook();
	        XSSFSheet sheet = workbook.createSheet("Record Violations");

	        XSSFRow titleRow = sheet.createRow(0);
	        titleRow.createCell(0).setCellValue("รายชื่อนักศึกษาที่กระทำผิดกฎจราจร");
	        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 8)); 

	        XSSFCell titleCell = titleRow.getCell(0);
	        XSSFRichTextString titleText = new XSSFRichTextString("รายชื่อนักศึกษาที่กระทำผิดกฎจราจร");
	        titleCell.setCellValue(titleText);
	        XSSFCellStyle titleStyle = workbook.createCellStyle();
	        titleStyle.setAlignment(HorizontalAlignment.CENTER); 
	        titleCell.setCellStyle(titleStyle);

	        // สร้างแถวหัวข้อคอลัมน์
	        XSSFRow headerRow = sheet.createRow(1);
	        
	        headerRow.createCell(0).setCellValue("ลำดับ");
	        headerRow.createCell(1).setCellValue("รหัสนักศึกษา");
	        headerRow.createCell(2).setCellValue("ชื่อ-นามสกุล");
	        headerRow.createCell(3).setCellValue("คณะ");
	        headerRow.createCell(4).setCellValue("สาขา");
	        headerRow.createCell(5).setCellValue("วันที่กระทำผิดกฎจราจร");
	        headerRow.createCell(6).setCellValue("สถานที่");
	        headerRow.createCell(7).setCellValue("ประเภทความผิด");
	        headerRow.createCell(8).setCellValue("สถานะ");

	        // การจัดรูปแบบข้อความของหัวข้อคอลัมน์
	        XSSFCellStyle headerStyle = workbook.createCellStyle();
	        headerStyle.setAlignment(HorizontalAlignment.CENTER); // จัดกลาง
	        for (int i = 0; i <= 8; i++) {
	            headerRow.getCell(i).setCellStyle(headerStyle);
	        }

	        // ใส่ข้อมูล RecordViolation ลงในแถวถัดไป
	        int rowNum = 2; // เริ่มแถวที่ 2
	        for (RecordViolation rv : pendingRV) {
	            XSSFRow row = sheet.createRow(rowNum++);
	            
	            row.createCell(0).setCellValue(rowNum - 2); // ลำดับ
	            row.createCell(1).setCellValue(rv.getStudent().getStudent_id());
	            row.createCell(2).setCellValue(rv.getStudent().getFirstname() + " " + rv.getStudent().getLastname());
	            row.createCell(3).setCellValue(rv.getStudent().getMajor());
	            row.createCell(4).setCellValue(rv.getStudent().getFaculty());
	            row.createCell(5).setCellValue(new SimpleDateFormat("dd/MM/yyyy").format(rv.getRecord_date()));
	            row.createCell(6).setCellValue(rv.getLocation().getLocation_name());
	            row.createCell(7).setCellValue(rv.getViolationType().getViolation_name());
	            row.createCell(8).setCellValue(rv.getStatus_type());
	        }

	        // ส่งไฟล์ Excel ไปที่ Client
	        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
	        response.setHeader("Content-Disposition", "attachment; filename=ListStudent_Violations.xlsx");

	        OutputStream out = response.getOutputStream();
	        workbook.write(out);
	        workbook.close();

	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ModelAndView("errorPage", "message", "เกิดข้อผิดพลาดในการส่งออกข้อมูล");
	    }
	    return null;
	}
	
	@RequestMapping(value = "/export-pdf-violation", method = RequestMethod.GET)
	public ModelAndView exportViolationPDF(HttpServletRequest request, HttpServletResponse response) {
	    try {
	        // ดึงข้อมูล RecordViolation
	        RecordViolationManager rvm = new RecordViolationManager();
	        List<RecordViolation> pendingRV = rvm.getListRVByStatus("กำลังพิจารณา");

	        // ตั้งค่า response เป็น PDF
	        response.setContentType("application/pdf");
	        response.setHeader("Content-Disposition", "attachment; filename=ListStudent_Violations.pdf");

	        OutputStream out = response.getOutputStream();
	        Document document = new Document(PageSize.A4, 20, 20, 30, 20); // กำหนดขนาดและขอบกระดาษ
	        PdfWriter.getInstance(document, out);

	        document.open();

	        // โหลดฟอนต์ภาษาไทย
	        String fontPath = getClass().getClassLoader().getResource("fonts/THSarabunNew.ttf").getPath();
	        BaseFont baseFont = BaseFont.createFont(fontPath, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	        Font titleFont = new Font(baseFont, 18, Font.BOLD);
	        Font subFont = new Font(baseFont, 16);
	        Font headerFont = new Font(baseFont, 16, Font.BOLD);
	        Font cellFont = new Font(baseFont, 14);

	        // เพิ่มส่วนหัวเอกสาร
	        Paragraph header = new Paragraph(
	            "ใบรายชื่อนักศึกษาที่ละเมิดกฎจราจร ภายในมหาวิทยาลัย\n", titleFont);
	        header.setAlignment(Element.ALIGN_CENTER);
	        document.add(header);

	        Paragraph subHeader = new Paragraph(
	            "สำหรับรายชื่อนักศึกษาที่ละเมิดกฎจราจร ซึ่งอยู่ในสถานะ 'กำลังพิจารณา'\n\n", subFont);
	        subHeader.setAlignment(Element.ALIGN_CENTER);
	        document.add(subHeader);

	        // เพิ่มตารางข้อมูล
	        PdfPTable table = new PdfPTable(new float[]{1, 2, (float) 2.3, (float) 2.3, (float) 2.5, (float) 3.7}); // กำหนดสัดส่วนคอลัมน์
	        table.setWidthPercentage(100);
	        table.setSpacingBefore(10f);
	        table.setSpacingAfter(10f);

	        // ตั้งค่าหัวตาราง
	        String[] headers = {
	            "ลำดับ", "รหัสนักศึกษา", "ชื่อ-นามสกุล", "คณะ", "สาขา", "ประเภทความผิด"
	        };
	        for (String headerText : headers) {
	            PdfPCell headerCell = new PdfPCell(new Phrase(headerText, headerFont));
	            headerCell.setHorizontalAlignment(Element.ALIGN_CENTER);
	            headerCell.setPadding(5);
	            headerCell.setFixedHeight(30);
	            table.addCell(headerCell);
	        }

	        // เพิ่มข้อมูลลงในตาราง
	        int index = 1;
	        for (RecordViolation rv : pendingRV) {
	            PdfPCell indexCell = new PdfPCell(new Phrase(String.valueOf(index++), cellFont));
	            indexCell.setHorizontalAlignment(Element.ALIGN_CENTER);
	            indexCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	            indexCell.setFixedHeight(20);
	            table.addCell(indexCell);

	            // รหัสนักศึกษา
	            PdfPCell studentIdCell = new PdfPCell(new Phrase(rv.getStudent().getStudent_id(), cellFont));
	            studentIdCell.setHorizontalAlignment(Element.ALIGN_CENTER);
	            studentIdCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	            studentIdCell.setFixedHeight(20);
	            table.addCell(studentIdCell);
	            
	            PdfPCell studentNameCell = new PdfPCell(new Phrase(rv.getStudent().getFirstname() + " " + rv.getStudent().getLastname(), cellFont));
	            studentNameCell.setHorizontalAlignment(Element.ALIGN_CENTER);
	            studentNameCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	            studentNameCell.setFixedHeight(20);
	            table.addCell(studentNameCell);
	           
	            PdfPCell facultyCell = new PdfPCell(new Phrase(rv.getStudent().getFaculty(), cellFont));
	            facultyCell.setHorizontalAlignment(Element.ALIGN_LEFT); // จัดข้อความชิดซ้าย
	            facultyCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	            facultyCell.setPaddingLeft(10);
	            facultyCell.setFixedHeight(20);
	            table.addCell(facultyCell); // คณะ

	            PdfPCell majorCell = new PdfPCell(new Phrase(rv.getStudent().getMajor(), cellFont));
	            majorCell.setHorizontalAlignment(Element.ALIGN_LEFT); // จัดข้อความชิดซ้าย
	            majorCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	            majorCell.setPaddingLeft(10);
	            majorCell.setFixedHeight(20);
	            table.addCell(majorCell); // สาขา

	            PdfPCell violationTypeCell = new PdfPCell(new Phrase(rv.getViolationType().getViolation_name(), cellFont));
	            violationTypeCell.setHorizontalAlignment(Element.ALIGN_LEFT); // จัดข้อความชิดซ้าย
	            violationTypeCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
	            violationTypeCell.setPaddingLeft(10);
	            violationTypeCell.setFixedHeight(20);
	            table.addCell(violationTypeCell);
	        }

	        // เพิ่มตารางลงใน PDF
	        document.add(table);

	        // เพิ่มส่วนท้ายเอกสาร
	        Paragraph subFooter = new Paragraph(
	        	    "\n\nลงชื่อ..............................................................\n" +
	        	    "(นายเตชิตร จันทร์อังคาร)\n" +
	        	    "หัวหน้าฝ่ายระเบียบวินัย กองพัฒนานักศึกษามหาวิทยาลัยแม่โจ้\n", subFont);
	        subFooter.setAlignment(Element.ALIGN_CENTER);
	        subFooter.setIndentationLeft(50); // ระยะจากขอบซ้าย (สามารถปรับได้ตามต้องการ)
	        subFooter.setIndentationRight(50); // ระยะจากขอบขวา
	        document.add(subFooter);


	        // ปิดเอกสาร
	        document.close();

	    } catch (Exception e) {
	        e.printStackTrace();
	        return new ModelAndView("errorPage", "message", "เกิดข้อผิดพลาดในการส่งออกข้อมูล");
	    }
	    return null;
	}




//------------------------------- APPROVED ----------------------------------
//	Record Violation Approved Page
	@RequestMapping(value = "/list-violation-approved", method = RequestMethod.GET)
	public ModelAndView recordViolationApprovedPage(HttpServletRequest request, HttpSession session) {
	    int page = 1; 
	    int size = 10; 
	   
	    String pageParam = request.getParameter("page");
	    if (pageParam != null && !pageParam.isEmpty()) {
	        page = Integer.parseInt(pageParam);
	    }
	
	    String sizeParam = request.getParameter("size");
	    if (sizeParam != null && !sizeParam.isEmpty()) {
	        size = Integer.parseInt(sizeParam);
	    }
	
	    RecordViolationManager rvm = new RecordViolationManager();
	    
	    List<RecordViolation> ListRV = rvm.getListRVApproved(page, size); // ใช้ Method สำหรับดึงข้อมูลสถานะ "อนุมัติ"
	    long totalRecords = rvm.getTotalRVApproved(); // นับเฉพาะ Record ที่อนุมัติแล้ว
	    long totalPages = (long) Math.ceil((double) totalRecords / size);
	
	    ModelAndView mav = new ModelAndView("list_violation_approved"); // เชื่อมโยงกับหน้าใหม่
	    mav.addObject("ListRVApproved", ListRV);
	    mav.addObject("currentPage", page);
	    mav.addObject("totalPages", totalPages);
	    mav.addObject("pageSize", size);
	    mav.addObject("totalRecords", totalRecords);
	
	    return mav;
	}

// ค้นหาเฉพาะข้อมูลที่อนุมัติแล้ว
	@RequestMapping(value = "/search-approved", method = RequestMethod.GET)
	public ModelAndView searchRecordViolationApproved(
	        @RequestParam(value = "searchText", required = false) String searchText,
	        @RequestParam(value = "startDate", required = false) String startDate,
	        @RequestParam(value = "page", required = false, defaultValue = "1") int page,
	        @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
	
	    ModelAndView mav = new ModelAndView("list_violation_approved"); // ใช้หน้าอนุมัติ
	    RecordViolationManager rvm = new RecordViolationManager();
	
	    if ((searchText == null || searchText.trim().isEmpty()) && (startDate == null || startDate.isEmpty())) {
	        mav.addObject("message", "กรุณากรอกข้อมูลในการค้นหา");
	        return mav;
	    }
	
	    List<RecordViolation> ListRV = rvm.getSearchRecordViolationApproved(searchText, startDate, page, size); // ใช้ Method ใหม่
	
	    if (ListRV == null || ListRV.isEmpty()) {
	        mav.addObject("message", "ไม่พบข้อมูล");
	    } else {
	        long totalRecords = rvm.getTotalSearchRVApproved(searchText, startDate); // ดึงจำนวนรวมที่อนุมัติแล้ว
	        long totalPages = (long) Math.ceil((double) totalRecords / size);
	
	        mav.addObject("ListRVApproved", ListRV);
	        mav.addObject("currentPage", page);
	        mav.addObject("totalPages", totalPages);
	        mav.addObject("pageSize", size);
	        mav.addObject("totalRecords", totalRecords);
	        mav.addObject("searchQuery", searchText);
	        mav.addObject("startQuery", startDate);
	    }
	
	    return mav;
	}

// Record Violation Detail Page (ไม่มีการเปลี่ยนแปลง)
	@RequestMapping(value = "/view-violation-approved", method = RequestMethod.GET)
	public ModelAndView recordViolationApprovedDetailPage(HttpServletRequest request) {
	    String record_id = request.getParameter("record_id");
	    RecordViolationManager rvm = new RecordViolationManager();
	    RecordViolation rec = rvm.getRecordViolationByID(record_id);
	
	    ModelAndView mav = new ModelAndView("view_violation_approved"); // เปลี่ยนไปใช้หน้ารายละเอียดใหม่
	    mav.addObject("RVA", rec);
	    return mav;
	}

//------------------------------- REJECTED ----------------------------------
//	Record Violation Rejected Page
	@RequestMapping(value = "/list-violation-rejected", method = RequestMethod.GET)
	public ModelAndView recordViolationRejectedPage(HttpServletRequest request, HttpSession session) {
	    int page = 1; 
	    int size = 10; 
	
	    String pageParam = request.getParameter("page");
	    if (pageParam != null && !pageParam.isEmpty()) {
	        page = Integer.parseInt(pageParam);
	    }
	
	    String sizeParam = request.getParameter("size");
	    if (sizeParam != null && !sizeParam.isEmpty()) {
	        size = Integer.parseInt(sizeParam);
	    }
	
	    RecordViolationManager rvm = new RecordViolationManager();
	    
	    List<RecordViolation> ListRV = rvm.getListRVRejected(page, size); // ใช้ Method สำหรับดึงข้อมูลสถานะ "อนุมัติ"
	    long totalRecords = rvm.getTotalRVRejected(); // นับเฉพาะ Record ที่อนุมัติแล้ว
	    long totalPages = (long) Math.ceil((double) totalRecords / size);
	
	    ModelAndView mav = new ModelAndView("list_violation_rejected"); // เชื่อมโยงกับหน้าใหม่
	    mav.addObject("ListRVRejected", ListRV);
	    mav.addObject("currentPage", page);
	    mav.addObject("totalPages", totalPages);
	    mav.addObject("pageSize", size);
	    mav.addObject("totalRecords", totalRecords);
	
	    return mav;
	}

// ค้นหาเฉพาะข้อมูลที่อนุมัติแล้ว
	@RequestMapping(value = "/search-rejected", method = RequestMethod.GET)
	public ModelAndView searchRecordViolationRejected(
	        @RequestParam(value = "searchText", required = false) String searchText,
	        @RequestParam(value = "startDate", required = false) String startDate,
	        @RequestParam(value = "page", required = false, defaultValue = "1") int page,
	        @RequestParam(value = "size", required = false, defaultValue = "10") int size) {
	
	    ModelAndView mav = new ModelAndView("list_violation_rejected"); // ใช้หน้าอนุมัติ
	    RecordViolationManager rvm = new RecordViolationManager();
	
	    if ((searchText == null || searchText.trim().isEmpty()) && (startDate == null || startDate.isEmpty())) {
	        mav.addObject("message", "กรุณากรอกข้อมูลในการค้นหา");
	        return mav;
	    }
	
	    List<RecordViolation> ListRV = rvm.getSearchRecordViolationRejected(searchText, startDate, page, size); // ใช้ Method ใหม่
	
	    if (ListRV == null || ListRV.isEmpty()) {
	        mav.addObject("message", "ไม่พบข้อมูล");
	    } else {
	        long totalRecords = rvm.getTotalSearchRVRejected(searchText, startDate); // ดึงจำนวนรวมที่อนุมัติแล้ว
	        long totalPages = (long) Math.ceil((double) totalRecords / size);
	
	        mav.addObject("ListRVRejected", ListRV);
	        mav.addObject("currentPage", page);
	        mav.addObject("totalPages", totalPages);
	        mav.addObject("pageSize", size);
	        mav.addObject("totalRecords", totalRecords);
	        mav.addObject("searchQuery", searchText);
	        mav.addObject("startQuery", startDate);
	    }
	
	    return mav;
	}

// Record Violation Detail Page (ไม่มีการเปลี่ยนแปลง)
	@RequestMapping(value = "/view-violation-rejected", method = RequestMethod.GET)
	public ModelAndView recordViolationRejectedDetailPage(HttpServletRequest request) {
	    String record_id = request.getParameter("record_id");
	    RecordViolationManager rvm = new RecordViolationManager();
	    RecordViolation rec = rvm.getRecordViolationByID(record_id);
	
	    ModelAndView mav = new ModelAndView("view_violation_rejected"); 
	    mav.addObject("RVR", rec);
	    return mav;
	}
	
	
//------------------------------ STATISTIC ----------------------------------
//	Statistics Violation Page
	@RequestMapping(value = "/statistics-violation", method = RequestMethod.GET)
	public ModelAndView statisticsViolationPage(
	    @RequestParam(value = "startDate", required = false) String startDateParam,
	    @RequestParam(value = "endDate", required = false) String endDateParam,
	    HttpServletRequest request
	) {
	    String defaultStartDate = LocalDate.now().withDayOfMonth(1).toString(); // วันที่ 1 ของเดือนปัจจุบัน
	    String defaultEndDate = LocalDate.now().toString(); // วันที่ปัจจุบัน

	    String startDate = (startDateParam != null) ? startDateParam : defaultStartDate;
	    String endDate = (endDateParam != null) ? endDateParam : defaultEndDate;

	    RecordViolationManager rvm = new RecordViolationManager();
	    Map<String, Long> countYearRV = rvm.getCountRVByTypeBetweenDates(startDate, endDate);
	    long totalYearRV = rvm.getTotalRVBetweenDates(startDate, endDate);

	    ModelAndView mav = new ModelAndView("statistics_violation");
	    mav.addObject("countViolation", countYearRV);
	    mav.addObject("totalViolation", totalYearRV);
	    mav.addObject("startDate", startDate); 
	    mav.addObject("endDate", endDate);

	    return mav;
	}


}
