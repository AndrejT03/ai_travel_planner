import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/plan_provider.dart';
import 'glass.dart';

class CreatePlanDialog extends ConsumerStatefulWidget {
  final String? initialDestination;

  const CreatePlanDialog({super.key, this.initialDestination});

  @override
  ConsumerState<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends ConsumerState<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();

  final _destinationCtrl = TextEditingController();
  final _daysCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();

  static const _seasons = ['Spring', 'Summer', 'Autumn', 'Winter'];
  String? _season;

  @override
  void initState() {
    super.initState();
    _destinationCtrl.text = widget.initialDestination ?? '';
  }

  @override
  void dispose() {
    _destinationCtrl.dispose();
    _daysCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(planControllerProvider);
    final isLoading = state is AsyncLoading;

    return Dialog(
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Center(
        child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
              padding: const EdgeInsets.only(top: 35),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF66B7FF).withOpacity(0.18),
                          Colors.black.withOpacity(0.92),
                        ],
                      ),
                    ),
                    child: Glass(
                      blur: 18,
                      opacity: 0.10,
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.all(18),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Create your next plan',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 18),
                              _input(
                                controller: _destinationCtrl,
                                label: 'Destination',
                                icon: Icons.place_outlined,
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 12),
                              _input(
                                controller: _daysCtrl,
                                label: 'Days of stay',
                                icon: Icons.calendar_today_outlined,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),
                              _input(
                                controller: _budgetCtrl,
                                label: 'Budget (EUR)',
                                icon: Icons.euro,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 12),
                              _seasonDropdown(),
                              const SizedBox(height: 18),
                              ElevatedButton(
                                onPressed: isLoading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF66B7FF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : const Text(
                                  'Create',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -25,
              right: -1,
              child: Material(
                color: Colors.black.withOpacity(0.35),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Close',
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            ],
        ),
      ),
    );
  }

  Widget _seasonDropdown() {
    return DropdownButtonFormField<String>(
      value: _season,
      items: _seasons
          .map((s) => DropdownMenuItem<String>(
        value: s,
        child: Text(s),
      ))
          .toList(),
      onChanged: (v) => setState(() => _season = v),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
      dropdownColor: const Color(0xFF0F141A),
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: 'Season',
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: const Icon(Icons.wb_sunny_outlined, color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.black.withOpacity(0.22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
      ),
      validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final destination = _destinationCtrl.text.trim();
    final days = int.tryParse(_daysCtrl.text.trim()) ?? 1;

    final budgetText = _budgetCtrl.text.trim().replaceAll(',', '.');
    final budget = double.tryParse(budgetText.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

    final seasonOrTime = _season!;

    context.pop();
    context.push('/plan-details');

    ref.read(planControllerProvider.notifier).createPlan(
      destination: destination,
      days: days,
      budget: budget,
      seasonOrTime: seasonOrTime,
    );
  }
}