import 'package:first_flutter/operations/admin_add.dart';
import 'package:first_flutter/operations/admin_remove.dart';
import 'package:first_flutter/operations/cinema_hall_add.dart';
import 'package:first_flutter/operations/cinema_hall_remove.dart';
import 'package:first_flutter/operations/movie_add.dart';
import 'package:first_flutter/operations/movie_remove.dart';
import 'package:first_flutter/operations/theatre_add.dart';
import 'package:first_flutter/operations/theatre_remove.dart';
import 'package:flutter/material.dart';

import 'operations/seat_add.dart';

enum ModelLabel {
  theatre('Theatre'),
  movie('Movie'),
  cinemaHall('Cinema Hall'),
  seat('Seat'),
  session('Session'),
  admin('Admin');

  const ModelLabel(this.label);
  final String label;
}

enum OperationLabel {
  add('Add'),
  remove('Remove');

  const OperationLabel(this.label);
  final String label;
}

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final TextEditingController modelController = TextEditingController();
  final TextEditingController operationController = TextEditingController();
  ModelLabel? selectedModel = ModelLabel.theatre;
  OperationLabel? selectedOperation = OperationLabel.add;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownMenu<ModelLabel>(
                      initialSelection: ModelLabel.theatre,
                      controller: modelController,
                      requestFocusOnTap: true,
                      label: const Text('Model'),
                      onSelected: (ModelLabel? model) {
                        setState(() {
                          selectedModel = model;
                        });
                      },
                      dropdownMenuEntries: ModelLabel.values
                          .map<DropdownMenuEntry<ModelLabel>>(
                              (ModelLabel model) {
                        return DropdownMenuEntry<ModelLabel>(
                          value: model,
                          label: model.label,
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 24),
                    DropdownMenu<OperationLabel>(
                      initialSelection: OperationLabel.add,
                      controller: operationController,
                      requestFocusOnTap: true,
                      label: const Text('Operation'),
                      onSelected: (OperationLabel? operation) {
                        setState(() {
                          selectedOperation = operation;
                        });
                      },
                      dropdownMenuEntries: OperationLabel.values
                          .map<DropdownMenuEntry<OperationLabel>>(
                              (OperationLabel operation) {
                        return DropdownMenuEntry<OperationLabel>(
                          value: operation,
                          label: operation.label,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              if (selectedModel != null && selectedOperation != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'You selected ${selectedModel?.label} ${selectedOperation?.label}'),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                    )
                  ],
                )
              else
                const Text('Please select a model and an operation.'),
              const SizedBox(
                height: 12.0,
              ),
              if (selectedModel == ModelLabel.theatre &&
                  selectedOperation == OperationLabel.add)
                const TheatreAdd(),
              if (selectedModel == ModelLabel.theatre &&
                  selectedOperation == OperationLabel.remove)
                const TheatreRemove(),
              if (selectedModel == ModelLabel.movie &&
                  selectedOperation == OperationLabel.add)
                const MovieAdd(),
              if (selectedModel == ModelLabel.movie &&
                  selectedOperation == OperationLabel.remove)
                const MovieRemove(),
              if (selectedModel == ModelLabel.cinemaHall &&
                  selectedOperation == OperationLabel.add)
                const CinemaHallAdd(),
              if (selectedModel == ModelLabel.cinemaHall &&
                  selectedOperation == OperationLabel.remove)
                const CinemaHallRemove(),
              if (selectedModel == ModelLabel.seat &&
                  selectedOperation == OperationLabel.add)
                const SeatAdd(),
              if (selectedModel == ModelLabel.admin &&
                  selectedOperation == OperationLabel.add)
                const AdminAdd(),
              if (selectedModel == ModelLabel.admin &&
                  selectedOperation == OperationLabel.remove)
                const AdminRemove(),
            ],
          ),
        ),
      ),
    );
  }
}
