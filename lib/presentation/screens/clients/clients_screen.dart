import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../widgets/custom_button.dart';
import 'add_client_screen.dart';
import 'client_details_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadClients() {
    context.read<ClientBloc>().add(ClientLoadAllEvent());
  }

  void _searchClients(String query) {
    if (query.isEmpty) {
      _loadClients();
    } else {
      context.read<ClientBloc>().add(ClientSearchEvent(query: query));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.clients),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClients,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.search,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadClients();
                  },
                ),
              ),
              onChanged: _searchClients,
            ),
          ),

          // Clients list
          Expanded(
            child: BlocBuilder<ClientBloc, ClientState>(
              builder: (context, state) {
                if (state is ClientLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ClientLoadedState) {
                  final clients = state.clients;

                  if (clients.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.noClients,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: localizations.addClient,
                            icon: Icons.person_add,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddClientScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadClients();
                    },
                    child: ListView.builder(
                      itemCount: clients.length,
                      itemBuilder: (context, index) {
                        final client = clients[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              client.name?.isNotEmpty == true
                                  ? client.name![0].toUpperCase()
                                  : client.phoneNumber[0],
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(client.name ?? localizations.client),
                          subtitle: Text(client.phoneNumber),
                          trailing: client.financialCeiling > 0
                              ? Text(
                                  '${localizations.ceiling}: ${client.financialCeiling}',
                                  style: const TextStyle(
                                    color: AppTheme.warningColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ClientDetailsScreen(
                                  clientId: client.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else if (state is ClientErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppTheme.errorColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppTheme.errorColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: localizations.retry,
                          onPressed: _loadClients,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddClientScreen(),
            ),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
