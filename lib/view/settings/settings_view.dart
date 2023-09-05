import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/offer_model.dart';
import '../../repo/admins_repo.dart';
import '../../repo/offer_repo.dart';
import '../../repo/settings_repo.dart';
import '../../state/auth_state.dart';
import '../../state/settings_state.dart';
import '../../util/snippet.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<SettingsState>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final SettingsState state = Provider.of<SettingsState>(context);
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: state.isLoading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: shimmerGridEffect(),
            secondChild: OfferGrid(),
          )),
    );
  }
}

class OfferGrid extends StatelessWidget {
  OfferGrid({
    super.key,
  });

  final GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SettingsState state = Provider.of<SettingsState>(context);
    final List<OfferModel> offers = state.offers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Offers',
              style: theme.textTheme.headlineSmall,
            ),
            ActionButtons()
          ],
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: offers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final OfferModel offer = offers[index];
            return OfferCard(offer: offer);
          },
        ),
      ],
    );
  }
}

class OfferCard extends StatelessWidget {
  OfferCard({super.key, required this.offer});
  final OfferModel offer;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            '${offer.price} RM',
            style: theme.textTheme.headlineSmall,
          ),
          subtitle: Text(
            '${offer.days} Days',
            style: theme.textTheme.titleSmall,
          ),
          trailing: Consumer<AuthState>(builder: (context, authState, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                authState.admin?.role != 'admin'
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () async {
                          String newPrice = '';
                          String newDays = '';
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Update Offer'),
                                    content: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            initialValue: offer.price,
                                            validator: mandatoryValidator,
                                            onSaved: (value) =>
                                                newPrice = value ?? '',
                                            decoration: InputDecoration(
                                              labelText: 'Price',
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            initialValue: offer.days,
                                            validator: mandatoryValidator,
                                            onSaved: (value) =>
                                                newDays = value ?? '',
                                            decoration: InputDecoration(
                                              labelText: 'Days',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            if (formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              formKey.currentState?.save();
                                              getStickyLoader(context);
                                              final OfferModel newOffer =
                                                  OfferModel(
                                                id: offer.id,
                                                name: offer.name,
                                                price: newPrice,
                                                days: newDays,
                                                isActive: offer.isActive,
                                              );
                                              await OfferRepo.instance
                                                  .updateOffer(newOffer);
                                              final SettingsState state =
                                                  Provider.of<SettingsState>(
                                                      context,
                                                      listen: false);
                                              state.loadData();
                                              snack(context, 'Offer Updated',
                                                  info: true);
                                            }
                                          } catch (e) {
                                            snack(context,
                                                'Error Updating Offer');
                                            print(e);
                                          }
                                          pop(context);
                                          pop(context);
                                        },
                                        child: Text('Update'),
                                      ),
                                    ],
                                  ));
                        },
                        icon: Icon(Icons.edit),
                        tooltip: 'Edit',
                      ),
                // const SizedBox(height: 8),
                Switch(
                  value: offer.isActive,
                  onChanged: authState.admin?.role != 'admin'
                      ? null
                      : (value) async {
                          try {
                            getStickyLoader(context);
                            final OfferModel newOffer = OfferModel(
                              id: offer.id,
                              name: offer.name,
                              price: offer.price,
                              days: offer.days,
                              isActive: value,
                            );
                            await OfferRepo.instance.updateOffer(newOffer);
                            final SettingsState state =
                                Provider.of<SettingsState>(context,
                                    listen: false);

                            final AuthState authState =
                                Provider.of<AuthState>(context, listen: false);

                            await AdminRepo.instance.addAdminLogs(
                                authState.admin!.email,
                                'Offer ${value ? 'activated' : 'deactivated'}');

                            state.loadData();
                            snack(context, 'Offer Updated', info: true);
                          } catch (e) {
                            snack(context, 'Error Updating Offer');
                            print(e);
                          }
                          pop(context);
                        },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ActionButtons extends StatelessWidget {
  ActionButtons({
    super.key,
  });
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String whatsappLink = '';
  String telegramLink = '';

  @override
  Widget build(BuildContext context) {
    final SettingsState state = Provider.of<SettingsState>(context);

    return Row(
      children: [
        Consumer<AuthState>(builder: (context, authState, _) {
          return ElevatedButton(
            onPressed: authState.admin?.role != 'admin'
                ? null
                : () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Update Contact Us Link'),
                              content: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      initialValue: state.whatsappLink,
                                      validator: mandatoryValidator,
                                      onSaved: (value) =>
                                          whatsappLink = value ?? '',
                                      decoration: InputDecoration(
                                        labelText: 'Whatsapp Link',
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      initialValue: state.telegramLink,
                                      validator: mandatoryValidator,
                                      onSaved: (value) =>
                                          telegramLink = value ?? '',
                                      decoration: InputDecoration(
                                        labelText: 'Telegram Link',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final SettingsState state =
                                        Provider.of<SettingsState>(context,
                                            listen: false);
                                    final AuthState authState =
                                        Provider.of<AuthState>(context,
                                            listen: false);

                                    try {
                                      getStickyLoader(context);
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        formKey.currentState?.save();
                                        await SettingsRepo.instance.updateLink(
                                            whatsappLink, telegramLink);
                                        await AdminRepo.instance.addAdminLogs(
                                            authState.admin!.email,
                                            'Contact Us Link updated');
                                        state.whatsappLink = whatsappLink;
                                        state.telegramLink = telegramLink;
                                        snack(context, 'Link Updated',
                                            info: true);
                                        pop(context);
                                      }
                                    } catch (e) {
                                      snack(context, e.toString());
                                    }
                                    pop(context);
                                  },
                                  child: Text('Update'),
                                ),
                              ],
                            ));
                  },
            child: Text('Update Link'),
          );
        }),
      ],
    );
  }
}
