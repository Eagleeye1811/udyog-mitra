import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_profile_provider.dart';

class AdditionalInfoSection extends ConsumerStatefulWidget {
  const AdditionalInfoSection({super.key});

  @override
  ConsumerState<AdditionalInfoSection> createState() =>
      _AdditionalInfoSectionState();
}

class _AdditionalInfoSectionState extends ConsumerState<AdditionalInfoSection> {
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
              title: const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                'Education, previous work, verification',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showEditDialog(context, ref),
                    icon: Icon(Icons.edit, color: Colors.green[600]),
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

            // Additional Info Content
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildAdditionalInfoContent(
                context,
                ref,
                userProfile,
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

  Widget _buildAdditionalInfoContent(
    BuildContext context,
    WidgetRef ref,
    userProfile,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),

          // Education
          _buildInfoTile(
            'Education',
            userProfile.education ?? 'Not specified',
            Icons.school,
            hasData: userProfile.education != null,
          ),

          const SizedBox(height: 16),

          // Previous Occupation
          _buildInfoTile(
            'Previous Occupation',
            userProfile.previousOccupation ?? 'Not specified',
            Icons.work_history,
            hasData: userProfile.previousOccupation != null,
          ),

          const SizedBox(height: 16),

          // Government ID Verification
          _buildVerificationTile(
            'Government ID Verification',
            userProfile.isGovernmentIdVerified,
          ),

          const SizedBox(height: 16),

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showEducationDialog(context, ref),
                  icon: const Icon(Icons.school, size: 16),
                  label: const Text('Update Education'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[600],
                    side: BorderSide(color: Colors.blue[300]!),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showOccupationDialog(context, ref),
                  icon: const Icon(Icons.work, size: 16),
                  label: const Text('Update Work'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange[600],
                    side: BorderSide(color: Colors.orange[300]!),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showVerificationDialog(context, ref),
              icon: Icon(
                userProfile.isGovernmentIdVerified
                    ? Icons.verified_user
                    : Icons.security,
                size: 16,
              ),
              label: Text(
                userProfile.isGovernmentIdVerified
                    ? 'Update Verification'
                    : 'Start Verification',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: userProfile.isGovernmentIdVerified
                    ? Colors.green[600]
                    : Colors.red[600],
                side: BorderSide(
                  color: userProfile.isGovernmentIdVerified
                      ? Colors.green[300]!
                      : Colors.red[300]!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    String label,
    String value,
    IconData icon, {
    bool hasData = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasData ? Colors.grey[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasData ? Colors.grey[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: hasData ? Colors.green[600] : Colors.orange[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: hasData ? Colors.black87 : Colors.orange[700],
                  ),
                ),
              ],
            ),
          ),
          if (!hasData)
            Icon(Icons.warning_amber, size: 20, color: Colors.orange[600]),
        ],
      ),
    );
  }

  Widget _buildVerificationTile(String label, bool isVerified) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVerified ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isVerified ? Icons.verified_user : Icons.security,
            size: 24,
            color: isVerified ? Colors.green[600] : Colors.red[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isVerified ? 'Verified' : 'Not Verified',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isVerified ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isVerified ? Icons.check_circle : Icons.error,
            size: 20,
            color: isVerified ? Colors.green[600] : Colors.red[600],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    final educationController = TextEditingController(
      text: userProfile.education ?? '',
    );
    final occupationController = TextEditingController(
      text: userProfile.previousOccupation ?? '',
    );
    bool isVerified = userProfile.isGovernmentIdVerified;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text(
            'Edit Additional Information',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: educationController,
                  decoration: const InputDecoration(
                    labelText: 'Education',
                    hintText: 'e.g., Higher Secondary Education',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.school),
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: occupationController,
                  decoration: const InputDecoration(
                    labelText: 'Previous Occupation',
                    hintText: 'e.g., Agricultural Worker',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.work_history),
                  ),
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                SwitchListTile(
                  title: const Text('Government ID Verified'),
                  subtitle: Text(
                    isVerified
                        ? 'Verification completed'
                        : 'Verification pending',
                  ),
                  value: isVerified,
                  onChanged: (value) {
                    setState(() {
                      isVerified = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
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
                    .updateAdditionalInfo(
                      education: educationController.text.trim().isEmpty
                          ? null
                          : educationController.text.trim(),
                      previousOccupation:
                          occupationController.text.trim().isEmpty
                          ? null
                          : occupationController.text.trim(),
                      isGovernmentIdVerified: isVerified,
                    );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Additional information updated'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEducationDialog(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    final educationController = TextEditingController(
      text: userProfile.education ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Education'),
        content: TextField(
          controller: educationController,
          decoration: const InputDecoration(
            labelText: 'Education',
            hintText: 'Enter your educational background',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
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
                  .updateAdditionalInfo(
                    education: educationController.text.trim().isEmpty
                        ? null
                        : educationController.text.trim(),
                  );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Education updated')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showOccupationDialog(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    final occupationController = TextEditingController(
      text: userProfile.previousOccupation ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Previous Occupation'),
        content: TextField(
          controller: occupationController,
          decoration: const InputDecoration(
            labelText: 'Previous Occupation',
            hintText: 'Enter your previous work experience',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
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
                  .updateAdditionalInfo(
                    previousOccupation: occupationController.text.trim().isEmpty
                        ? null
                        : occupationController.text.trim(),
                  );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Previous occupation updated')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showVerificationDialog(BuildContext context, WidgetRef ref) {
    final userProfile = ref.read(userProfileProvider);
    if (userProfile == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Government ID Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              userProfile.isGovernmentIdVerified
                  ? Icons.verified_user
                  : Icons.security,
              size: 64,
              color: userProfile.isGovernmentIdVerified
                  ? Colors.green
                  : Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              userProfile.isGovernmentIdVerified
                  ? 'Your government ID is verified'
                  : 'Verify your government ID to access more features',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (!userProfile.isGovernmentIdVerified) ...[
              const SizedBox(height: 16),
              const Text(
                'Verification provides:\n• Enhanced security\n• Access to government schemes\n• Faster application processing',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (!userProfile.isGovernmentIdVerified)
            ElevatedButton(
              onPressed: () async {
                // Simulate verification process
                await ref
                    .read(userProfileProvider.notifier)
                    .updateAdditionalInfo(isGovernmentIdVerified: true);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification status updated')),
                );
              },
              child: const Text('Start Verification'),
            ),
        ],
      ),
    );
  }
}
