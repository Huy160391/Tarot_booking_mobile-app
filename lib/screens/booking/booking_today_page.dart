import 'package:flutter/material.dart';
import 'package:tarot/api/booking_api.dart';
import 'package:tarot/model/booking_model.dart';
import 'package:intl/intl.dart';

class BookingTOdayPage extends StatefulWidget {
  final String readerId;

  const BookingTOdayPage({Key? key, required this.readerId}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingTOdayPage> {
  List<BookingItem> filteredBookings = [];
  TextEditingController searchController = TextEditingController();
  DateTime? selectedDate;
  final AllBookingApi _api = AllBookingApi();
  bool isLoading = true;
  int pageNumber = 1;
  final int pageSize = 10;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();  // Default to today's date
    _fetchBookings(date: selectedDate);  // Make sure to trigger the API call
  }

  Future<void> _fetchBookings({
    String? searchTerm,
    DateTime? date,
    int? pageNum,
  }) async {
    setState(() => isLoading = true);
    try {
      // Logging to debug date values and API calls
      print("Fetching bookings for date: $date");

      if (date != null) {
        DateTime startDate = DateTime(date.year, date.month, date.day, 0, 0, 01);
        DateTime endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

        // Make the API call to fetch bookings for the selected date range
        final BookingModel bookingData = await _api.fetchPagedBookings(
          readerId: widget.readerId,
          searchTerm: searchTerm,
          startDate: startDate,
          endDate: endDate,
          pageNumber: pageNum ?? pageNumber,
          pageSize: pageSize,
        );

        // Debug log for the number of bookings fetched
        print("Fetched ${bookingData.bookings.length} bookings");

        setState(() {
          filteredBookings = bookingData.bookings;
          if (pageNum != null) {
            pageNumber = pageNum;
          }
        });
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _filterBookings() {
    String query = searchController.text.trim();
    _fetchBookings(
      searchTerm: query.isEmpty ? null : query,
      date: selectedDate,
    );
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
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
        selectedDate = pickedDate;
        pageNumber = 1;
      });
      _fetchBookings(date: selectedDate);
    }
  }

  void _nextPage() {
    setState(() => pageNumber++);
    _fetchBookings(date: selectedDate, pageNum: pageNumber);
  }

  void _prevPage() {
    if (pageNumber > 1) {
      setState(() => pageNumber--);
      _fetchBookings(date: selectedDate, pageNum: pageNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/tarotpage.jpg'),
                fit: BoxFit.cover,
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
                      onChanged: (value) => _filterBookings(),
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
                              onPressed: _selectDate,
                              child: Text(
                                selectedDate != null
                                    ? 'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}'
                                    : 'Select Date',
                                style: TextStyle(color: Colors.black),
                              ),
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
                    : filteredBookings.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredBookings.length,
                            itemBuilder: (context, index) {
                              var booking = filteredBookings[index];
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    'Date: ${DateFormat('yyyy-MM-dd').format(booking.booking.timeStart ?? DateTime.now())} - Slot: ${DateFormat('HH:mm').format(booking.booking.timeStart ?? DateTime.now())} - ${DateFormat('HH:mm').format(booking.booking.timeEnd ?? DateTime.now())}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Deck: ${booking.userName}'),
                                      Text('Note: ${booking.booking.note ?? ''}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              'No bookings found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
