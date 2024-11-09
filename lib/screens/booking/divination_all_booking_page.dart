import 'package:flutter/material.dart';
import 'package:tarot/api/booking_api.dart';
import 'package:tarot/model/booking_model.dart';
import 'package:intl/intl.dart';

class DivinationAllPage extends StatefulWidget {
  final String readerId;

  DivinationAllPage({required this.readerId});

  @override
  _DivinationAllPageState createState() => _DivinationAllPageState();
}

class _DivinationAllPageState extends State<DivinationAllPage> {
  List<BookingItem> filteredSessions = [];
  TextEditingController searchController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  List<int> selectedStatuses = [];
  final AllBookingApi _api = AllBookingApi();
  bool isLoading = true;
  int pageNumber = 1;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings({
    String? searchTerm,
    DateTime? startDate,
    DateTime? endDate,
    List<int>? statuses,
  }) async {
    setState(() => isLoading = true);
    try {
      final BookingModel bookingData = await _api.fetchPagedBookings(
        readerId: widget.readerId,
        searchTerm: searchTerm,
        startDate: startDate,
        endDate: endDate,
        statuses: statuses,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      setState(() {
        filteredSessions = bookingData.bookings;
      });
    } catch (e) {
      print('Error fetching bookings: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterSessions() {
    String query = searchController.text.trim();
    _fetchBookings(
      searchTerm: query.isEmpty ? null : query,
      startDate: startDate,
      endDate: endDate,
      statuses: selectedStatuses.isNotEmpty ? selectedStatuses : null,
    );
  }

  Future<void> _selectStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 202, 201, 204),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        startDate = pickedDate;
      });
      _filterSessions();
    }
  }

  Future<void> _selectEndDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromARGB(255, 202, 201, 204),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        endDate = pickedDate;
      });
      _filterSessions();
    }
  }

  void _nextPage() {
    setState(() => pageNumber++);
    _fetchBookings();
  }

  void _prevPage() {
    if (pageNumber > 1) {
      setState(() => pageNumber--);
      _fetchBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Divination Sessions History'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.darken),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: (value) => _filterSessions(),
                      decoration: InputDecoration(
                        labelText: 'Search by deck or topic',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: _selectStartDate,
                              child: Text(
                                startDate != null
                                    ? 'Start Date: ${DateFormat('yyyy-MM-dd').format(startDate!)}'
                                    : 'Select Start Date',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: _selectEndDate,
                              child: Text(
                                endDate != null
                                    ? 'End Date: ${DateFormat('yyyy-MM-dd').format(endDate!)}'
                                    : 'Select End Date',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select Status',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              items: [
                                DropdownMenuItem(value: 0, child: Text('No Selection')),
                                DropdownMenuItem(value: 1, child: Text('Not done')),
                                DropdownMenuItem(value: 2, child: Text('Done (not reviewed)')),
                                DropdownMenuItem(value: 3, child: Text('Feedback provided')),
                                DropdownMenuItem(value: 4, child: Text('Canceled')),
                              ],
                              onChanged: (int? newStatus) {
                                setState(() {
                                  if (newStatus == 0) {
                                    selectedStatuses.clear();
                                  } else if (newStatus != null) {
                                    selectedStatuses.contains(newStatus)
                                        ? selectedStatuses.remove(newStatus)
                                        : selectedStatuses.add(newStatus);
                                  }
                                });
                                _filterSessions();
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredSessions.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredSessions.length,
                            itemBuilder: (context, index) {
                              var session = filteredSessions[index];
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    'Date: ${DateFormat('yyyy-MM-dd').format(session.booking.timeStart ?? DateTime.now())} - Slot: ${DateFormat('HH:mm').format(session.booking.timeStart ?? DateTime.now())} - ${DateFormat('HH:mm').format(session.booking.timeEnd ?? DateTime.now())}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Deck: ${session.userName}', style: TextStyle(color: Colors.black)),
                                      Text('Note: ${session.booking.note ?? ''}', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                  trailing: Text(
                                    _getStatusText(session.booking.status),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(session.booking.status),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No sessions found',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _prevPage,
                    child: Text('Previous Page'),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text('Next Page'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Not Pay';
      case 1:
        return 'Not done';
      case 2:
        return 'Done (not reviewed)';
      case 3:
        return 'Feedback provided';
      case 4:
        return 'Canceled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.yellow;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
