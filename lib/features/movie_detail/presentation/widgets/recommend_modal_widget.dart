import 'package:flutter/material.dart';

import 'package:arq_mobile/core/l10n/app_localizations.dart';
import 'package:arq_mobile/core/widgets/app_toast.dart';

import 'package:arq_mobile/features/movie_detail/domain/entities/movie_detail.dart';

class RecommendModalWidget extends StatefulWidget {
  // [Constructor]
  const RecommendModalWidget({super.key, required this.detail});

  // [Properties]
  final MovieDetail detail;

  // [Methods]
  @override
  State<RecommendModalWidget> createState() => _RecommendModalWidgetState();
}

class _RecommendModalWidgetState extends State<RecommendModalWidget> {
  // [Properties]
  final _commentController = TextEditingController();

  // [Methods]
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _confirm(BuildContext pageContext, AppLocalizations l10n) {
    Navigator.of(context).pop();
    AppToast.show(
      pageContext,
      message: l10n.recommendSuccess,
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // pageContext keeps the ScaffoldMessenger alive after the modal closes
    final pageContext = Navigator.of(context).context;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // [Title]
              Text(
                l10n.recommendModalTitle,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // [Movie overview]
              Text(
                widget.detail.overview,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              // [Comment field]
              TextField(
                controller: _commentController,
                minLines: 3,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: l10n.recommendCommentHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),
              // [Confirm button]
              ValueListenableBuilder(
                valueListenable: _commentController,
                builder: (_, value, _) => ElevatedButton(
                  onPressed: value.text.trim().isEmpty
                      ? null
                      : () => _confirm(pageContext, l10n),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(l10n.recommendConfirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
