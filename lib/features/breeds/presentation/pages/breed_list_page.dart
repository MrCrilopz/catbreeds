import 'package:catbreeds/core/constants/app_layout.dart';
import 'package:catbreeds/core/layout/breakpoint_scope.dart';
import 'package:catbreeds/features/breeds/domain/entities/breed.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_bloc.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_event.dart';
import 'package:catbreeds/features/breeds/presentation/bloc/breeds_state.dart';
import 'package:catbreeds/features/breeds/presentation/pages/breed_detail_page.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_list.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_search_field.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/breed_skeleton.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/empty_search.dart';
import 'package:catbreeds/features/breeds/presentation/widgets/load_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final breedRoutes = RouteObserver<ModalRoute<void>>();

class BreedListPage extends StatefulWidget {
  const BreedListPage({super.key});

  static const route = '/breeds';

  @override
  State<BreedListPage> createState() => _BreedListPageState();
}

class _BreedListPageState extends State<BreedListPage> with RouteAware {
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  ModalRoute<dynamic>? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route == null || route == _route) {
      return;
    }
    if (_route != null) {
      breedRoutes.unsubscribe(this);
    }
    _route = route;
    breedRoutes.subscribe(this, route);
  }

  @override
  void dispose() {
    breedRoutes.unsubscribe(this);
    _search.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    _searchFocus.canRequestFocus = false;
    _searchFocus.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _searchFocus.canRequestFocus = true;
      });
    });
  }

  Future<void> _refresh() {
    final bloc = context.read<BreedsBloc>();
    final done = bloc.stream.firstWhere(
      (state) => state is BreedsReady || state is BreedsFailure,
    );
    bloc.add(const BreedsRequested());
    return done;
  }

  void _open(Breed breed) {
    _searchFocus.unfocus();
    Navigator.of(context).pushNamed(BreedDetailPage.route, arguments: breed.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catbreeds')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BreakpointScope(
            breakpoint: BreakpointScope.fromWidth(constraints.maxWidth),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppMeasure.content),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpace.lg,
                        0,
                        AppSpace.lg,
                        AppSpace.lg,
                      ),
                      child: BreedSearchField(
                        controller: _search,
                        focusNode: _searchFocus,
                        onChanged: (value) {
                          setState(() {});
                          context.read<BreedsBloc>().add(
                            BreedQueryChanged(value),
                          );
                        },
                        onClear: () {
                          _search.clear();
                          setState(() {});
                          context.read<BreedsBloc>().add(
                            const BreedQueryChanged(''),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: BlocConsumer<BreedsBloc, BreedsState>(
                        listenWhen: (previous, next) {
                          return previous is! BreedsReady &&
                              next is BreedsReady;
                        },
                        listener: (context, state) {
                          if (state is BreedsReady &&
                              _search.text != state.query) {
                            context.read<BreedsBloc>().add(
                              BreedQueryChanged(_search.text),
                            );
                          }
                        },
                        builder: (context, state) {
                          return RefreshIndicator(
                            onRefresh: _refresh,
                            child: switch (state) {
                              BreedsInitial() ||
                              BreedsLoading() => const _Skeletons(),
                              BreedsFailure() => LoadError(
                                onRetry: () => _refresh(),
                              ),
                              BreedsReady(:final visible, :final query) =>
                                visible.isEmpty
                                    ? EmptySearch(query: query)
                                    : BreedList(breeds: visible, onOpen: _open),
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Skeletons extends StatelessWidget {
  const _Skeletons();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando razas',
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpace.lg,
          0,
          AppSpace.lg,
          AppSpace.lg,
        ),
        itemCount: 6,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpace.lg),
        itemBuilder: (_, _) => const BreedSkeleton(),
      ),
    );
  }
}
