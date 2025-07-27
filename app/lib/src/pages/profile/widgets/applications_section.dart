import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/helpers.dart';
import '../../../providers/user_profile_provider.dart';
import '../../../models/user_profile.dart';

class ApplicationsSection extends ConsumerStatefulWidget {
  const ApplicationsSection({super.key});

  @override
  ConsumerState<ApplicationsSection> createState() =>
      _ApplicationsSectionState();
}

class _ApplicationsSectionState extends ConsumerState<ApplicationsSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    if (userProfile == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            // Header
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              title: Text(
                'Applications Overview',
                style: context.textStyles.titleMedium,
              ),
              subtitle: userProfile.applications.isNotEmpty
                  ? Text(
                      '${userProfile.applications.length} application${userProfile.applications.length != 1 ? 's' : ''}',
                      style: context.textStyles.labelSmall.grey(context),
                    )
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showAddApplicationDialog(context, ref),
                    icon: Icon(Icons.add, color: Colors.green[600]),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Applications List
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildApplicationsList(
                context,
                ref,
                userProfile.applications,
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationsList(
    BuildContext context,
    WidgetRef ref,
    List<Application> applications,
  ) {
    if (applications.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: _buildEmptyState(context, ref),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: applications
            .map(
              (application) => _buildApplicationCard(context, ref, application),
            )
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Icon(Icons.description_outlined, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text(
          'No applications yet',
          style: context.textStyles.bodySmall.grey(context),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => _showAddApplicationDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Add Application'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildApplicationCard(
    BuildContext context,
    WidgetRef ref,
    Application application,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    application.type.icon,
                    size: 24,
                    color: Colors.green[600],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          application.title,
                          style: context.textStyles.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          application.type.displayName,
                          style: context.textStyles.labelSmall.grey(context),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'details':
                          _showApplicationDetails(context, application);
                          break;
                        case 'status':
                          _showUpdateStatusDialog(context, ref, application);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 18),
                            SizedBox(width: 8),
                            Text('View Details'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'status',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Update Status'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _buildStatusBadge(application.status),
                  const Spacer(),
                  Text(
                    'Applied: ${DateFormat('MMM dd, yyyy').format(application.dateApplied)}',
                    style: context.textStyles.labelSmall.grey(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ApplicationStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: context.textStyles.labelSmall.copyWith(color: status.color),
          ),
        ],
      ),
    );
  }

  void _showAddApplicationDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    ApplicationType selectedType = ApplicationType.scheme;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Application', style: context.textStyles.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Application Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<ApplicationType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Application Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: ApplicationType.values.map((type) {
                  return DropdownMenuItem<ApplicationType>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(type.icon, size: 20),
                        const SizedBox(width: 8),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter application title'),
                    ),
                  );
                  return;
                }

                final newApplication = Application(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  type: selectedType,
                  status: ApplicationStatus.pending,
                  dateApplied: DateTime.now(),
                );

                await ref
                    .read(userProfileProvider.notifier)
                    .addApplication(newApplication);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Application added successfully'),
                  ),
                );
              },
              child: const Text('Add Application'),
            ),
          ],
        ),
      ),
    );
  }

  void _showApplicationDetails(BuildContext context, Application application) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(application.title, style: context.textStyles.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              'Type',
              application.type.displayName,
              application.type.icon,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Status',
              application.status.displayName,
              application.status.icon,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              'Date Applied',
              DateFormat('MMM dd, yyyy').format(application.dateApplied),
              Icons.calendar_today,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.textStyles.labelSmall.grey(context)),
            Text(value, style: context.textStyles.bodyMedium),
          ],
        ),
      ],
    );
  }

  void _showUpdateStatusDialog(
    BuildContext context,
    WidgetRef ref,
    Application application,
  ) {
    ApplicationStatus selectedStatus = application.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            'Update Application Status',
            style: context.textStyles.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ApplicationStatus.values.map((status) {
              return RadioListTile<ApplicationStatus>(
                title: Row(
                  children: [
                    Icon(status.icon, size: 20, color: status.color),
                    const SizedBox(width: 8),
                    Text(status.displayName),
                  ],
                ),
                value: status,
                groupValue: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref
                    .read(userProfileProvider.notifier)
                    .updateApplicationStatus(application.id, selectedStatus);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Application status updated')),
                );
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
