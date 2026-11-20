import 'package:flutter/material.dart';

void main() => runApp(const MajalisLibraryApp());

class MajalisLibraryApp extends StatelessWidget {
  const MajalisLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مكتبة مجالس الجامعة',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: const WelcomeScreen(),
    );
  }
}

class Account {
  final String name, email, password;
  Account(this.name, this.email, this.password);
}

class Book {
  final String title, author, description;
  bool borrowed;
  Book(this.title, this.author, this.description, {this.borrowed = false});
}

final List<Account> accounts = [];
final List<Book> books = [
  Book('مقدمة في البرمجة', 'أحمد سالم', 'كتاب مبسط للتعرف على أساسيات البرمجة.'),
  Book('هياكل البيانات', 'منى خالد', 'شرح للمصفوفات والقوائم والخوارزميات.'),
  Book('تطوير تطبيقات Flutter', 'سارة علي', 'دليل لبناء تطبيقات متعددة الشاشات.'),
  Book('قواعد البيانات', 'محمد حسن', 'مفاهيم قواعد البيانات والاستعلامات.'),
  Book('الذكاء الاصطناعي', 'ريم عبدالله', 'مدخل إلى مفاهيم الذكاء الاصطناعي.'),
];

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.local_library, size: 90, color: Color(0xFF6750A4)),
        const SizedBox(height: 16),
        const Text('مكتبة مجالس الجامعة', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const Text('University Majalis Library', textAlign: TextAlign.center),
        const SizedBox(height: 28),
        FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen())), child: const Text('تسجيل الدخول')),
        TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('إنشاء حساب جديد')),
      ]),
    )),
  );
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController(), email = TextEditingController(), password = TextEditingController();
  String message = '';
  @override
  void dispose() { name.dispose(); email.dispose(); password.dispose(); super.dispose(); }
  void register() {
    if (name.text.trim().isEmpty || email.text.trim().isEmpty || password.text.isEmpty) {
      setState(() => message = 'يرجى تعبئة جميع الحقول'); return;
    }
    if (!email.text.contains('@') || !email.text.contains('.')) {
      setState(() => message = 'البريد الإلكتروني غير صحيح'); return;
    }
    if (accounts.any((a) => a.email.toLowerCase() == email.text.trim().toLowerCase())) {
      setState(() => message = 'هذا البريد مسجل مسبقًا'); return;
    }
    accounts.add(Account(name.text.trim(), email.text.trim(), password.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب، سجلي الدخول الآن')));
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) => FormScaffold(title: 'إنشاء حساب', children: [
    field(name, 'اسم المستخدم'), field(email, 'البريد الإلكتروني', type: TextInputType.emailAddress),
    field(password, 'كلمة المرور', secret: true),
    if (message.isNotEmpty) Text(message, style: const TextStyle(color: Colors.red)),
    FilledButton(onPressed: register, child: const Text('تسجيل')),
  ]);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(), password = TextEditingController();
  String message = '';
  void login() {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      setState(() => message = 'يرجى إدخال البريد وكلمة المرور'); return;
    }
    final found = accounts.where((a) => a.email.toLowerCase() == email.text.trim().toLowerCase() && a.password == password.text);
    if (found.isEmpty) { setState(() => message = 'بيانات الدخول غير صحيحة'); return; }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(user: found.first)));
  }
  @override
  Widget build(BuildContext context) => FormScaffold(title: 'تسجيل الدخول', children: [
    field(email, 'البريد الإلكتروني', type: TextInputType.emailAddress), field(password, 'كلمة المرور', secret: true),
    if (message.isNotEmpty) Text(message, style: const TextStyle(color: Colors.red)),
    FilledButton(onPressed: login, child: const Text('دخول')),
    TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())), child: const Text('ليس لديك حساب؟ إنشاء حساب')),
  ]);
}

class FormScaffold extends StatelessWidget {
  final String title; final List<Widget> children;
  const FormScaffold({super.key, required this.title, required this.children});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: SingleChildScrollView(child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Icon(Icons.menu_book, size: 64, color: Color(0xFF6750A4)),
        const SizedBox(height: 20), ...children.map((w) => Padding(padding: const EdgeInsets.only(bottom: 14), child: w)),
      ]),
    ))),
  );
}

Widget field(TextEditingController controller, String label, {bool secret = false, TextInputType type = TextInputType.text}) =>
  TextField(controller: controller, obscureText: secret, keyboardType: type, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()));

class HomeScreen extends StatefulWidget {
  final Account user;
  const HomeScreen({super.key, required this.user});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(user: widget.user, onBrowse: () => setState(() => index = 1)),
      BrowseTab(onOpen: (book) => Navigator.push(context, MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)))),
      const BorrowedTab(),
      ProfileTab(user: widget.user, onLogout: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (_) => false)),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('مكتبة مجالس الجامعة')),
      body: pages[index],
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (i) => setState(() => index = i), destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        NavigationDestination(icon: Icon(Icons.search), label: 'البحث'),
        NavigationDestination(icon: Icon(Icons.bookmark_outline), label: 'استعارتي'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
      ]),
    );
  }
}

class HomeTab extends StatelessWidget {
  final Account user; final VoidCallback onBrowse;
  const HomeTab({super.key, required this.user, required this.onBrowse});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    Text('أهلًا ${user.name} 👋', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8), const Text('اكتشفي الكتب الجامعية واستعيري ما تحتاجينه.'),
    const SizedBox(height: 20), Card(child: ListTile(leading: const Icon(Icons.library_books, size: 40), title: const Text('تصفحي مكتبة الكتب'), subtitle: Text('${books.length} كتب متاحة'), trailing: const Icon(Icons.arrow_forward), onTap: onBrowse)),
    const SizedBox(height: 12), const Text('كتب مقترحة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    ...books.take(3).map((b) => ListTile(leading: const Icon(Icons.menu_book), title: Text(b.title), subtitle: Text(b.author))),
  ]);
}

class BrowseTab extends StatefulWidget {
  final ValueChanged<Book> onOpen;
  const BrowseTab({super.key, required this.onOpen});
  @override
  State<BrowseTab> createState() => _BrowseTabState();
}
class _BrowseTabState extends State<BrowseTab> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final filtered = books.where((b) => b.title.contains(query) || b.author.contains(query)).toList();
    return Column(children: [
      Padding(padding: const EdgeInsets.all(16), child: TextField(onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحثي عن كتاب أو مؤلف', border: OutlineInputBorder())),
      Expanded(child: ListView.builder(itemCount: filtered.length, itemBuilder: (_, i) {
        final b = filtered[i];
        return Card(margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), child: ListTile(leading: const Icon(Icons.menu_book, color: Color(0xFF6750A4)), title: Text(b.title), subtitle: Text('${b.author} • ${b.borrowed ? "مستعار" : "متاح"}'), trailing: const Icon(Icons.chevron_left), onTap: () => widget.onOpen(b)));
      })),
    ]);
  }
}

class BookDetailsScreen extends StatefulWidget {
  final Book book;
  const BookDetailsScreen({super.key, required this.book});
  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}
class _BookDetailsScreenState extends State<BookDetailsScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تفاصيل الكتاب')),
    body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Center(child: Icon(Icons.menu_book, size: 100, color: Color(0xFF6750A4))),
      Text(widget.book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), Text('المؤلف: ${widget.book.author}'),
      const SizedBox(height: 16), Text(widget.book.description),
      const Spacer(),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: widget.book.borrowed ? null : () {
        setState(() => widget.book.borrowed = true);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت استعارة الكتاب')));
      }, child: Text(widget.book.borrowed ? 'الكتاب مستعار' : 'استعارة الكتاب'))),
    ])),
  );
}

class BorrowedTab extends StatefulWidget {
  const BorrowedTab({super.key});
  @override
  State<BorrowedTab> createState() => _BorrowedTabState();
}
class _BorrowedTabState extends State<BorrowedTab> {
  @override
  Widget build(BuildContext context) {
    final borrowed = books.where((b) => b.borrowed).toList();
    return borrowed.isEmpty ? const Center(child: Text('لا توجد كتب مستعارة حتى الآن')) :
      ListView(children: borrowed.map((b) => ListTile(leading: const Icon(Icons.bookmark), title: Text(b.title), subtitle: Text(b.author), trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async {
        final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('تأكيد الإرجاع'), content: const Text('هل تريدين إرجاع هذا الكتاب؟'), actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('إرجاع')),
        ]));
        if (ok == true) setState(() => b.borrowed = false);
      })).toList());
  }
}

class ProfileTab extends StatelessWidget {
  final Account user; final VoidCallback onLogout;
  const ProfileTab({super.key, required this.user, required this.onLogout});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 50)),
    const SizedBox(height: 16), Center(child: Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
    Center(child: Text(user.email)),
    const SizedBox(height: 24), FilledButton.tonal(onPressed: onLogout, child: const Text('تسجيل الخروج')),
  ]);
}
