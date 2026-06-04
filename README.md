# 📚 LearnHub - E-Learning Application

تطبيق تعليمي متكامل للهواتف الذكية تم تطويره باستخدام إطار العمل **Flutter**. يهدف التطبيق إلى تسهيل إدارة المساقات التعليمية ومتابعة تقدم الطلاب بأسلوب سلس وتفاعلي.

---

## ✨ ميزات التطبيق (Features)
- **إدارة المساقات (Course Management):** استعراض قائمة المساقات والتفاصيل الخاصة بكل مساق (المدرب، التقييم، عدد الدروس، والوقت).
- **إدارة حالة التطبيق (State Management):** الاعتماد على حزمة `Provider` لإدارة حالة البيانات والتفاعل مع الواجهات بكفاءة عالية.
- **الحفظ المحلي (Local Storage):** استخدام `SharedPreferences` لحفظ بيانات المستخدم وتفضيلاته محلياً (مثل تفعيل الوضع الليلي Dark Mode وحفظ التغييرات على البروفايل).
- **التنقل المتقدم (Navigation):** هيكلة شاشات التطبيق باستخدام نظام تنقل مرن ونظيف (`MainNavigation`, `SplashScreen`).
- **البحث والتصنيف:** إمكانية البحث عن المساقات وتصفيتها حسب الفئة (Category) لتسهيل الوصول للمحتوى.

---

## 🛠️ التقنيات المستخدمة (Tech Stack)
- **Framework:** Flutter (Dart)
- **State Management:** Provider
- **Local Storage:** SharedPreferences
- **Testing:** JUnit Workflow / Flutter Unit Testing

---

## 📂 مستندات وتحليل النظام (Project Documentation)

تم توثيق كافة مراحل هندسة البرمجيات وتحليل المتطلبات الخاصة بالمشروع، ويمكنكم الإطلاع عليها مباشرة عبر الروابط التالية داخل المستودع:

### 📋 التقارير ومراحل التحليل (Reports)
- [📝 وثيقة دراسة المشكلة وجدوى النظام - Problem Statement & Business Case](doc/01_Problem_Statement_Business_Case.pdf)
- [📅 مخطط غانت لجدولة المشروع - Planning Gantt Chart](doc/02_Planning_Gantt_Chart.pdf)
- [🔍 جمع وتحليل المتطلبات - Requirements Gathering](doc/03_Requirements_Gathering.pdf)
- [🔄 نموذج دورة حياة النظام المستخدم - SDLC Model](doc/04_SDLC_Model.pdf)
- [⚙️ تحليل المتطلبات الوظيفية - Functional Requirements Analysis](doc/05_Functional_Requirements_Analysis.pdf)

### 🎨 التصاميم والمخططات الهندسية (UML & UI)
- [📐 مخطط الحالات الاستخدامية - Use Case Diagram](doc/Use%20Case%20digram.pdf)
- [📱 التصميم المبدئي لواجهات التطبيق - UI Mockups](doc/UI%20Mockups.pdf)
- [🌐 التوثيق المولد برمجياً للكود - API Dart Documentation](doc/api/index.html)

---

## 👥 فريق العمل (Development Team)
المشروع تم تطويره بواسطة طلاب كلية تكنولوجيا المعلومات:
- **إيمان العودات (Eman Aladat)** 


---
### 🚀 طريقة تشغيل المشروع محلياً (How to Run)
1. قم بتحميل المستودع (Clone).
2. افتح الترمينال ونفذ الأمر: `flutter pub get` لتحميل الحزم.
3. لتشغيل التطبيق: `flutter run`.
4. لتشغيل الاختبارات المتكاملة: `flutter test`.