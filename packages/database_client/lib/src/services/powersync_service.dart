import 'package:powersync/powersync.dart';

class PowerSyncService {
  late final PowerSyncDatabase database;

  Future<void> initialize() async {
    // TODO: Configure PowerSync schema and connector
    // This will be completed when Supabase + PowerSync backend details are available.
  }

  PowerSyncDatabase get db => database;
}