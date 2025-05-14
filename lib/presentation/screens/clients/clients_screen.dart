import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/data_utils.dart';
import '../../../core/utils/ui_utils.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/client/client_bloc.dart';
import '../../bloc/client/client_event.dart';
import '../../bloc/client/client_state.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/empty_widget.dart';
import 'add_client_screen.dart';
import 'client_details_screen.dart';
import 'client_item.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final _searchController = TextEditingController();
  // Sort order: true for ascending (oldest first), false for descending (newest first)
  bool _sortAscending = false;

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
    // Use YER as the default currency
    context
        .read<ClientBloc>()
        .add(const ClientLoadAllEvent(currencyCode: 'YER'));
  }

  void _searchClients(String query) {
    if (query.isEmpty) {
      _loadClients();
    } else {
      // Use YER as the default currency
      context.read<ClientBloc>().add(
            ClientSearchEvent(
              query: query,
              currencyCode: 'YER',
            ),
          );
    }
  }

  void _toggleSortOrder() {
    setState(() {
      _sortAscending = !_sortAscending;
    });
  }

  // Sort clients by createdAt date using utility method
  List<dynamic> _sortClients(List<dynamic> clients) {
    return DataUtils.sortClientsByDate(
      clients.cast<ClientModel>(),
      ascending: _sortAscending,
    );
  }

  void _showAddTransactionDialog(BuildContext context, String clientId) {
    UiUtils.showAddTransactionBottomSheet(context, clientId);
  }

  void _showAddClientBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.9, // 90% of screen height
            minChildSize: 0.5, // Minimum 50% of screen height
            maxChildSize: 0.95, // Maximum 95% of screen height
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  // Use the AddClientBottomSheet from add_client_screen.dart
                  child: const AddClientBottomSheet(),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.clients),
        actions: [
          // Sort button with appropriate icon based on current sort order
          IconButton(
            icon: Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            tooltip:
                '${localizations.createdAt} (${_sortAscending ? "Oldest first" : "Newest first"})',
            onPressed: _toggleSortOrder,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadClients,
          ),
        ],
      ),
      body: BlocListener<ClientBloc, ClientState>(
        listener: (context, state) {
          if (state is ClientAddedState) {
            SnackBarUtils.showSuccessSnackBar(
              context,
              message: localizations.clientAddedSuccess,
            );
          } else if (state is ClientUpdatedState) {
            SnackBarUtils.showSuccessSnackBar(
              context,
              message: localizations.clientUpdatedSuccess,
            );
          } else if (state is ClientDeletedState) {
            SnackBarUtils.showSuccessSnackBar(
              context,
              message: localizations.clientDeletedSuccess,
            );
          } else if (state is ClientErrorState) {
            SnackBarUtils.showErrorSnackBar(
              context,
              message: state.message,
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTextField(
                controller: _searchController,
                labelText: localizations.search,
                prefixIcon: Icons.search,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadClients();
                  },
                ),
                onChanged: _searchClients,
              ),
            ),
            Expanded(
              child: BlocBuilder<ClientBloc, ClientState>(
                builder: (context, state) {
                  if (state is ClientLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ClientLoadedState) {
                    // Apply sorting to the clients list
                    final clients = _sortClients(state.clients);

                    if (clients.isEmpty) {
                      // Check if this is a search with no results
                      if (_searchController.text.isNotEmpty) {
                        return EmptyWidget(
                          message:
                              '${localizations.noSearchResults} "${_searchController.text}"',
                          icon: Icons.search_off,
                          iconColor: Colors.grey.shade400,
                          iconSize: 80,
                        );
                      }

                      // No clients at all
                      return EmptyWidget(
                        message: localizations.noClients,
                        icon: Icons.emoji_emotions_outlined,
                        iconColor: Colors.grey.shade400,
                        iconSize: 80,
                        actionText: localizations.addClient,
                        onAction: () {
                          _showAddClientBottomSheet(context);
                        },
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async => _loadClients(),
                      child: ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];

                          return ClientItem(
                            client: client,
                            localizations: localizations,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => ClientDetailsScreen(
                                        clientId: client.id)),
                              );
                            },
                            onAddTransaction: () =>
                                _showAddTransactionDialog(context, client.id),
                          );
                        },
                      ),
                    );
                  } else if (state is ClientErrorState) {
                    return EmptyWidget(
                      message: state.message,
                      icon: Icons.error_outline,
                      iconColor: AppTheme.errorColor,
                      iconSize: 80,
                      actionText: localizations.retry,
                      onAction: _loadClients,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddClientBottomSheet(context);
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
