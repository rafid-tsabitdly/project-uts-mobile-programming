import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const UnpamWifiApp());
}

// ─── MODELS ───────────────────────────────────────────────────────────────────

class WifiPackage {
  final String id, name, description;
  final int price;
  final String speed, color1, color2, icon;
  final List<String> features;

  WifiPackage({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.speed,
    required this.color1,
    required this.color2,
    required this.icon,
    required this.features,
  });
}

class Subscription {
  final String id, packageId, packageName, speed;
  final int price;
  final DateTime startDate, endDate;
  final String status;

  Subscription({
    required this.id,
    required this.packageId,
    required this.packageName,
    required this.speed,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.status,
  });
}

class PaymentHistory {
  final String id, packageName, method, invoiceNo;
  final int amount;
  final DateTime date;
  final String status;

  PaymentHistory({
    required this.id,
    required this.packageName,
    required this.method,
    required this.invoiceNo,
    required this.amount,
    required this.date,
    required this.status,
  });
}

// ─── APP STATE ────────────────────────────────────────────────────────────────

class AppState extends ChangeNotifier {
  List<Subscription> subscriptions = [];
  List<PaymentHistory> payments = [];

  void addSubscription(WifiPackage pkg, String method) {
    final now = DateTime.now();
    final sub = Subscription(
      id: 'SUB${DateTime.now().millisecondsSinceEpoch}',
      packageId: pkg.id,
      packageName: pkg.name,
      speed: pkg.speed,
      price: pkg.price,
      startDate: now,
      endDate: DateTime(now.year, now.month + 6, now.day),
      status: 'Aktif',
    );
    subscriptions.insert(0, sub);

    final pay = PaymentHistory(
      id: 'PAY${DateTime.now().millisecondsSinceEpoch}',
      packageName: pkg.name,
      method: method,
      invoiceNo: 'INV-${Random().nextInt(900000) + 100000}',
      amount: pkg.price,
      date: now,
      status: 'Berhasil',
    );
    payments.insert(0, pay);
    notifyListeners();
  }
}

// ─── GLOBAL DATA ──────────────────────────────────────────────────────────────

final appState = AppState();

final List<WifiPackage> packages = [
  WifiPackage(
    id: 'silver',
    name: 'Silver',
    description: 'Paket hemat untuk browsing & email',
    price: 20000,
    speed: '2 Mbps',
    color1: '#64B5F6',
    color2: '#1565C0',
    icon: '🥈',
    features: [
      'Kecepatan 2 Mbps',
      'Valid 1 Semester (6 Bulan)',
      'Akses 24 Jam',
      'Area Kampus UNPAM',
      'Support Email',
    ],
  ),
  WifiPackage(
    id: 'gold',
    name: 'Gold',
    description: 'Paket premium untuk streaming & belajar online',
    price: 50000,
    speed: '5 Mbps',
    color1: '#FFD54F',
    color2: '#F57F17',
    icon: '🥇',
    features: [
      'Kecepatan 5 Mbps',
      'Valid 1 Semester (6 Bulan)',
      'Akses 24 Jam',
      'Area Kampus UNPAM',
      'Prioritas Bandwidth',
      'Support 24/7',
    ],
  ),
];

const List<Map<String, dynamic>> paymentMethods = [
  {
    'id': 'transfer',
    'name': 'Transfer Bank',
    'icon': Icons.account_balance,
    'desc': 'BCA / Mandiri / BNI / BRI'
  },
  {
    'id': 'gopay',
    'name': 'GoPay',
    'icon': Icons.account_balance_wallet,
    'desc': 'Dompet Digital GoPay'
  },
  {
    'id': 'ovo',
    'name': 'OVO',
    'icon': Icons.wallet,
    'desc': 'Dompet Digital OVO'
  },
  {
    'id': 'dana',
    'name': 'DANA',
    'icon': Icons.payments,
    'desc': 'Dompet Digital DANA'
  },
  {
    'id': 'qris',
    'name': 'QRIS',
    'icon': Icons.qr_code_2,
    'desc': 'Scan QR Code Mana Saja'
  },
];

// ─── COLORS & THEME ───────────────────────────────────────────────────────────

const Color kPrimary = Color(0xFF1565C0);
const Color kPrimaryLight = Color(0xFF1E88E5);
const Color kPrimaryDark = Color(0xFF0D47A1);
const Color kAccent = Color(0xFF00E5FF);
const Color kBg = Color(0xFFF0F4FF);
const Color kCard = Colors.white;
const Color kText = Color(0xFF0D1B3E);
const Color kTextSub = Color(0xFF5C7099);

// ─── MAIN APP ─────────────────────────────────────────────────────────────────

class UnpamWifiApp extends StatelessWidget {
  const UnpamWifiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UNPAM WiFi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

// ─── SALOMON BOTTOM BAR ───────────────────────────────────────────────────────

class SalomonBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SalomonBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    {'icon': Icons.wifi_rounded, 'label': 'Home'},
    {'icon': Icons.subscriptions_rounded, 'label': 'Langganan'},
    {'icon': Icons.receipt_long_rounded, 'label': 'Riwayat'},
    {'icon': Icons.person_rounded, 'label': 'Profil'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: selected ? 20 : 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? kPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i]['icon'] as IconData,
                        color: selected ? Colors.white : kTextSub,
                        size: 22,
                      ),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        Text(
                          _items[i]['label'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─── MAIN SHELL ───────────────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;

  final _pages = const [
    HomeScreen(),
    SubscriptionScreen(),
    HistoryScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(key: ValueKey(_idx), child: _pages[_idx]),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
      ),
    );
  }
}

// ─── HOME SCREEN ──────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: kPrimaryDark,
          flexibleSpace: FlexibleSpaceBar(
            background: _HomeHeader(),
          ),
          title: const Text(
            'UNPAM WiFi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon:
                  const Icon(Icons.notifications_rounded, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle('Paket WiFi Semester'),
                const SizedBox(height: 14),
                ...packages.map((p) => _PackageCard(package: p)),
                const SizedBox(height: 24),
                _SectionTitle('Kenapa UNPAM WiFi?'),
                const SizedBox(height: 14),
                _FeaturesGrid(),
                const SizedBox(height: 24),
                _InfoBanner(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
        ),
      ),
      child: Stack(
        children: [
          // decorative circles
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kAccent.withOpacity(0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kAccent.withOpacity(0.4)),
                  ),
                  child: const Text(
                    '🎓 Universitas Pamulang',
                    style: TextStyle(
                        color: kAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Internet Kampus\nSetiap Semester',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mulai dari Rp 20.000 / semester',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _SectionTitle(String text) => Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: kText,
      ),
    );

class _PackageCard extends StatelessWidget {
  final WifiPackage package;
  const _PackageCard({required this.package});

  Color _hex(String hex) {
    return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
  }

  bool get isGold => package.id == 'gold';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isGold
              ? [const Color(0xFF1565C0), const Color(0xFF0D47A1)]
              : [const Color(0xFF1976D2), const Color(0xFF1565C0)],
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (isGold)
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(package.icon, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Paket ${package.name}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isGold) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFD54F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'POPULER',
                                  style: TextStyle(
                                    color: Color(0xFF7B5800),
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          package.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.speed,
                          style: const TextStyle(
                            color: kAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Kecepatan Download',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Rp ${_formatPrice(package.price)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'per semester',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      package.features.map((f) => _FeatureChip(f)).toList(),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentFlowScreen(package: package),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Berlangganan Sekarang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isGold ? const Color(0xFF1565C0) : kPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String text;
  const _FeatureChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 10),
      ),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  final _data = const [
    {
      'icon': Icons.speed_rounded,
      'title': 'Kecepatan Stabil',
      'sub': 'Jaringan fiber optik'
    },
    {
      'icon': Icons.security_rounded,
      'title': 'Aman & Terpercaya',
      'sub': 'Dikelola IT UNPAM'
    },
    {
      'icon': Icons.support_agent_rounded,
      'title': 'Support 24/7',
      'sub': 'Tim siap membantu'
    },
    {
      'icon': Icons.location_on_rounded,
      'title': 'Area Kampus',
      'sub': 'Semua gedung UNPAM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: _data
          .map(
            (d) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: kPrimary.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(d['icon'] as IconData, color: kPrimary, size: 24),
                  const SizedBox(height: 6),
                  Text(
                    d['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: kText,
                    ),
                  ),
                  Text(
                    d['sub'] as String,
                    style: const TextStyle(fontSize: 10, color: kTextSub),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPrimary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info_rounded, color: kPrimary, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Berlaku 1 Semester',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: kText, fontSize: 13),
                ),
                SizedBox(height: 2),
                Text(
                  'Paket aktif selama 6 bulan setelah pembayaran dikonfirmasi',
                  style: TextStyle(color: kTextSub, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PAYMENT FLOW SCREEN ──────────────────────────────────────────────────────

class PaymentFlowScreen extends StatefulWidget {
  final WifiPackage package;
  const PaymentFlowScreen({super.key, required this.package});

  @override
  State<PaymentFlowScreen> createState() => _PaymentFlowScreenState();
}

class _PaymentFlowScreenState extends State<PaymentFlowScreen> {
  int _step = 0; // 0=pilih, 1=input, 2=konfirmasi
  String? _selectedMethod;
  final _nameCtrl = TextEditingController();
  final _nimCtrl = TextEditingController();

  String get _methodName =>
      paymentMethods.firstWhere((m) => m['id'] == _selectedMethod,
          orElse: () => {'name': ''})['name'] as String;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nimCtrl.dispose();
    super.dispose();
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _StepSelectMethod(
          selected: _selectedMethod,
          onSelect: (id) => setState(() => _selectedMethod = id),
          onNext:
              _selectedMethod != null ? () => setState(() => _step = 1) : null,
        );
      case 1:
        return _StepInputData(
          nameCtrl: _nameCtrl,
          nimCtrl: _nimCtrl,
          onNext: () {
            if (_nameCtrl.text.isNotEmpty && _nimCtrl.text.isNotEmpty) {
              setState(() => _step = 2);
            }
          },
          onBack: () => setState(() => _step = 0),
        );
      case 2:
        return _StepConfirm(
          package: widget.package,
          method: _methodName,
          name: _nameCtrl.text,
          nim: _nimCtrl.text,
          onConfirm: () {
            appState.addSubscription(widget.package, _methodName);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentSuccessScreen(
                    package: widget.package, method: _methodName),
              ),
            );
          },
          onBack: () => setState(() => _step = 1),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    const stepLabels = ['Metode', 'Data Diri', 'Konfirmasi'];
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kPrimaryDark,
        foregroundColor: Colors.white,
        title: Text(
          'Berlangganan Paket ${widget.package.name}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // stepper
          Container(
            color: kPrimaryDark,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Row(
              children: List.generate(3, (i) {
                final done = i < _step;
                final active = i == _step;
                return Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: done || active
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: done
                                  ? const Icon(Icons.check,
                                      color: kPrimary, size: 16)
                                  : Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        color: active
                                            ? kPrimary
                                            : Colors.white.withOpacity(0.5),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stepLabels[i],
                            style: TextStyle(
                              color: done || active
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      if (i < 2)
                        Expanded(
                          child: Container(
                            height: 2,
                            margin: const EdgeInsets.only(bottom: 18),
                            color: done
                                ? Colors.white
                                : Colors.white.withOpacity(0.2),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(child: SingleChildScrollView(child: _buildStep())),
        ],
      ),
    );
  }
}

// step 1 - pilih metode
class _StepSelectMethod extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onSelect;
  final VoidCallback? onNext;

  const _StepSelectMethod(
      {required this.selected, required this.onSelect, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pilih Metode Pembayaran',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: kText)),
          const SizedBox(height: 4),
          const Text('Pilih salah satu metode di bawah ini',
              style: TextStyle(color: kTextSub, fontSize: 13)),
          const SizedBox(height: 20),
          ...paymentMethods.map((m) {
            final isSelected = selected == m['id'];
            return GestureDetector(
              onTap: () => onSelect(m['id'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? kPrimary : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: kPrimary.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4))
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimary.withOpacity(0.1) : kBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(m['icon'] as IconData,
                          color: isSelected ? kPrimary : kTextSub, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m['name'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? kPrimary : kText,
                                fontSize: 14,
                              )),
                          Text(m['desc'] as String,
                              style: const TextStyle(
                                  color: kTextSub, fontSize: 11)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(Icons.check_circle_rounded,
                          color: kPrimary, size: 22),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                disabledBackgroundColor: Colors.grey.shade200,
              ),
              child: const Text('Lanjutkan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// step 2 - input data
class _StepInputData extends StatelessWidget {
  final TextEditingController nameCtrl, nimCtrl;
  final VoidCallback onNext, onBack;

  const _StepInputData({
    required this.nameCtrl,
    required this.nimCtrl,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data Mahasiswa',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: kText)),
          const Text('Isi data diri kamu dengan benar',
              style: TextStyle(color: kTextSub, fontSize: 13)),
          const SizedBox(height: 24),
          _inputField('Nama Lengkap', 'Contoh: Muhammad Rafid', nameCtrl,
              Icons.person_outline_rounded),
          const SizedBox(height: 14),
          _inputField(
              'NIM', 'Contoh: 241011701060', nimCtrl, Icons.badge_outlined),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: Color(0xFFF9A825), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pastikan NIM sesuai KTM. Data ini digunakan untuk aktivasi WiFi kamu.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF7B5800)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    side: const BorderSide(color: kPrimary),
                  ),
                  child: const Text('Kembali',
                      style: TextStyle(
                          color: kPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Lanjutkan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputField(
      String label, String hint, TextEditingController ctrl, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: kText, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kTextSub, fontSize: 13),
            prefixIcon: Icon(icon, color: kPrimary, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kPrimary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

// step 3 - konfirmasi
class _StepConfirm extends StatelessWidget {
  final WifiPackage package;
  final String method, name, nim;
  final VoidCallback onConfirm, onBack;

  const _StepConfirm({
    required this.package,
    required this.method,
    required this.name,
    required this.nim,
    required this.onConfirm,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: kPrimary.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // package info
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(colors: [kPrimary, kPrimaryDark]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Text(package.icon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Paket ${package.name}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          Text(package.speed,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Rp ${_formatPrice(package.price)}',
                        style: const TextStyle(
                            color: kAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _ConfirmRow('Nama', name),
                _ConfirmRow('NIM', nim),
                _ConfirmRow('Metode', method),
                _ConfirmRow('Masa Aktif', '6 Bulan (1 Semester)'),
                const Divider(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Pembayaran',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: kText)),
                    Text(
                      'Rp ${_formatPrice(package.price)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: kPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFA5D6A7)),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_rounded, color: Color(0xFF2E7D32), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Transaksi diproses secara aman. Aktivasi WiFi dalam 1×24 jam setelah pembayaran.',
                    style: TextStyle(fontSize: 11, color: Color(0xFF2E7D32)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    side: const BorderSide(color: kPrimary),
                  ),
                  child: const Text('Kembali',
                      style: TextStyle(
                          color: kPrimary, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Bayar Sekarang',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _ConfirmRow(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kTextSub, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: kText, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );

// ─── PAYMENT SUCCESS SCREEN ───────────────────────────────────────────────────

class PaymentSuccessScreen extends StatelessWidget {
  final WifiPackage package;
  final String method;
  const PaymentSuccessScreen(
      {super.key, required this.package, required this.method});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)]),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF66BB6A).withOpacity(0.35),
                        blurRadius: 24,
                        spreadRadius: 4)
                  ],
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 52),
              ),
              const SizedBox(height: 28),
              const Text('Pembayaran Berhasil!',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold, color: kText)),
              const SizedBox(height: 8),
              Text(
                'Paket ${package.name} ${package.speed} telah aktif.\nNikmati WiFi kampus UNPAM selama 1 semester!',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: kTextSub, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: kPrimary.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  children: [
                    _SuccessRow('Paket', '${package.icon} ${package.name}'),
                    _SuccessRow('Kecepatan', package.speed),
                    _SuccessRow('Total', 'Rp ${_formatPrice(package.price)}'),
                    _SuccessRow('Metode', method),
                    _SuccessRow('Masa Aktif', '6 Bulan'),
                    _SuccessRow('Status', '✅ Aktif'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Kembali ke Beranda',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _SuccessRow(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kTextSub, fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  color: kText, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );

// ─── SUBSCRIPTION SCREEN ──────────────────────────────────────────────────────

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (_, __) {
        final subs = appState.subscriptions;
        return CustomScrollView(
          slivers: [
            _BlueAppBar('Langganan Saya', Icons.subscriptions_rounded),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: subs.isEmpty
                    ? _EmptyState(
                        icon: Icons.wifi_off_rounded,
                        title: 'Belum Ada Langganan',
                        sub: 'Yuk berlangganan WiFi kampus sekarang!',
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // active count badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: kPrimary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${subs.length} Langganan',
                              style: const TextStyle(
                                  color: kPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...subs.map((s) => _SubCard(sub: s)),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubCard extends StatelessWidget {
  final Subscription sub;
  const _SubCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    final daysLeft = sub.endDate.difference(DateTime.now()).inDays;
    final progress = 1 - (daysLeft / 180);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: kPrimary.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [kPrimary, kPrimaryDark]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.wifi_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sub.packageName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: kText)),
                    Text(sub.speed,
                        style: const TextStyle(color: kTextSub, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  sub.status,
                  style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Sisa $daysLeft hari',
                  style: const TextStyle(fontSize: 12, color: kTextSub)),
              Text(
                '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}% terpakai',
                style: const TextStyle(fontSize: 12, color: kTextSub),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: kBg,
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _MiniInfo(Icons.calendar_today_rounded,
                  '${_fmtDate(sub.startDate)} – ${_fmtDate(sub.endDate)}'),
              const Spacer(),
              _MiniInfo(
                  Icons.payments_rounded, 'Rp ${_formatPrice(sub.price)}'),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _MiniInfo(IconData icon, String text) => Row(
      children: [
        Icon(icon, size: 13, color: kTextSub),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 11, color: kTextSub)),
      ],
    );

// ─── HISTORY SCREEN ───────────────────────────────────────────────────────────

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (_, __) {
        final pays = appState.payments;
        return CustomScrollView(
          slivers: [
            _BlueAppBar('Riwayat Pembayaran', Icons.receipt_long_rounded),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: pays.isEmpty
                    ? _EmptyState(
                        icon: Icons.receipt_long_rounded,
                        title: 'Belum Ada Transaksi',
                        sub: 'Riwayat pembayaran akan muncul di sini',
                      )
                    : Column(
                        children: [
                          // Summary card
                          Container(
                            padding: const EdgeInsets.all(18),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [kPrimary, kPrimaryDark]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _StatItem('Total Transaksi', '${pays.length}x'),
                                Container(
                                    width: 1,
                                    height: 40,
                                    color: Colors.white24),
                                _StatItem('Total Bayar',
                                    'Rp ${_formatPrice(pays.fold<int>(0, (s, p) => s + p.amount))}'),
                              ],
                            ),
                          ),
                          ...pays.map((p) => _PayCard(pay: p)),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label, value;
  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 11)),
        ],
      );
}

class _PayCard extends StatelessWidget {
  final PaymentHistory pay;
  const _PayCard({required this.pay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: kPrimary.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: Color(0xFF2E7D32), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Paket ${pay.packageName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: kText)),
                Text('${pay.method} • ${pay.invoiceNo}',
                    style: const TextStyle(color: kTextSub, fontSize: 11)),
                Text(_fmtDate(pay.date),
                    style: const TextStyle(color: kTextSub, fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp ${_formatPrice(pay.amount)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14, color: kPrimary),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  pay.status,
                  style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── PROFILE SCREEN ───────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: kPrimaryDark,
          flexibleSpace: FlexibleSpaceBar(
            background: _ProfileHeader(),
          ),
          title: const Text('Profil Mahasiswa',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _ProfileInfoCard(),
                const SizedBox(height: 16),
                _MenuSection('Akun', [
                  _MenuItem(Icons.wifi_rounded, 'Paket Aktif',
                      'Lihat langganan aktif', kPrimary),
                  _MenuItem(Icons.history_rounded, 'Riwayat',
                      'Lihat semua transaksi', kPrimary),
                  _MenuItem(Icons.notifications_rounded, 'Notifikasi',
                      'Atur notifikasi', kPrimary),
                ]),
                const SizedBox(height: 16),
                _MenuSection('Bantuan', [
                  _MenuItem(Icons.help_rounded, 'FAQ', 'Pertanyaan umum',
                      Colors.orange),
                  _MenuItem(Icons.headset_mic_rounded, 'Kontak Support',
                      'Hubungi tim IT UNPAM', Colors.green),
                  _MenuItem(Icons.info_rounded, 'Tentang Aplikasi',
                      'Versi 1.0.0', kTextSub),
                ]),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.school_rounded,
                          color: Color(0xFFF57F17), size: 24),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Universitas Pamulang',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: kText,
                                    fontSize: 13)),
                            Text(
                                'Jl. Surya Kencana No.1, Pamulang\nTangerang Selatan, Banten',
                                style: TextStyle(
                                    color: kTextSub,
                                    fontSize: 11,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1E88E5)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 16,
                    spreadRadius: 2)
              ],
            ),
            child: const Center(
              child: Text('MR',
                  style: TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22)),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Muhammad Rafid Tsabitdly',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(height: 4),
          Text('241011701060 • 04SIFE008',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.75), fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (_, __) {
        final active =
            appState.subscriptions.where((s) => s.status == 'Aktif').length;
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: kPrimary.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ProfileStat('Langganan', '$active Aktif', Icons.wifi_rounded),
              Container(width: 1, height: 50, color: Colors.grey.shade200),
              _ProfileStat('Transaksi', '${appState.payments.length}x',
                  Icons.receipt_long_rounded),
              Container(width: 1, height: 50, color: Colors.grey.shade200),
              _ProfileStat('Prodi', 'Sist. Info', Icons.school_rounded),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _ProfileStat(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: kPrimary, size: 20),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: kText, fontSize: 13)),
          Text(label, style: const TextStyle(color: kTextSub, fontSize: 10)),
        ],
      );
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _MenuSection(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: kPrimary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kTextSub,
                    fontSize: 11,
                    letterSpacing: 1)),
          ),
          ...items.asMap().entries.map((e) {
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                e.value,
                if (!isLast)
                  Divider(
                      indent: 52,
                      endIndent: 16,
                      height: 1,
                      color: Colors.grey.shade100),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  final Color color;
  const _MenuItem(this.icon, this.title, this.sub, this.color);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 13, color: kText)),
      subtitle:
          Text(sub, style: const TextStyle(color: kTextSub, fontSize: 11)),
      trailing:
          const Icon(Icons.chevron_right_rounded, color: kTextSub, size: 20),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────────────────────────

SliverAppBar _BlueAppBar(String title, IconData icon) => SliverAppBar(
      pinned: true,
      backgroundColor: kPrimaryDark,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white),
          const SizedBox(width: 8),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  const _EmptyState(
      {required this.icon, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: kPrimary.withOpacity(0.4)),
            ),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: kText)),
            const SizedBox(height: 6),
            Text(sub,
                style: const TextStyle(color: kTextSub, fontSize: 13),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── HELPERS ──────────────────────────────────────────────────────────────────

String _formatPrice(int price) {
  return price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}

String _fmtDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agt',
  'Sep',
  'Okt',
  'Nov',
  'Des'
];
