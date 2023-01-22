import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> problemDialogBuilder(BuildContext context, GlobalKey<FormState> formKey) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.reportProblem),
            content: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title:
                            Text(AppLocalizations.of(context)!.problemArtist),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title: Text(AppLocalizations.of(context)!.problemSound),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title: Text(
                            AppLocalizations.of(context)!.problemSuspicious),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    FormField<bool>(
                      builder: (state) => CheckboxListTile(
                        onChanged: state.didChange,
                        title: Text(AppLocalizations.of(context)!.problemOther),
                        value: state.value!,
                      ),
                      initialValue: false,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .problemOtherComment),
                      enabled: false,
                    ),
                  ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.submit),
              ),
            ],
          );
        });
  }
