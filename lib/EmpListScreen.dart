import 'package:app/editscreen.dart';
import 'package:app/model/employee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Make sure you have provider package

// Import your EmpProvider
import 'EmpProvider.dart'; // Adjust path if needed

class EmpListScreen extends StatefulWidget {
  const EmpListScreen({Key? key}) : super(key: key);

  @override
  _EmpListScreenState createState() => _EmpListScreenState();
}

class _EmpListScreenState extends State<EmpListScreen> {
  late ScrollController _scrollController;
  TextEditingController _srchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Fetch data after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmpProvider>(context, listen: false)
          .fetchEmployee(); // Call  fetch method
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final EmpProvider _provider = Provider.of<EmpProvider>(context,
            listen: false); // Get provider here
        if (_provider.hasMore) {
          // print("Fetching more data...");

          _provider.fetchMore();
        } else {
          print("No more data to load");
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _srchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Data"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Consumer<EmpProvider>(
            // Use Consumer for rebuilds
            builder: (context, _provider, child) {
              // Access provider here
              return Column(
                children: [
                  TextField(
                    controller: _srchController,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    onChanged: (value) {
                      _provider.srchData(_srchController.text, "department");
                    },
                    decoration: InputDecoration(
                      hintText: "Search here..",
                    ),
                  ),

                  const SizedBox(height: 20), // Make const if it doesn't change

                  _provider.isLoading &&
                          _provider.emps
                              .isEmpty // Check if loading and list is empty
                      ? const Center(
                          child:
                              CircularProgressIndicator()) // Center the indicator
                      : Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.only(bottom: 30),
                            controller: _scrollController,
                            itemCount: _provider.emps.length + 1,
                            itemBuilder: (context, index) {
                              if (index == _provider.emps.length) {
                                return _provider.loadMore
                                    ? Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 50,
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : SizedBox();
                              }
                              final emp = _provider.emps[index];
                              // Store in a variable for easier access
                              return DataCard(emp: emp);
                            },
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.emp,
  });

  final Emp emp;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        // Add padding for better visual
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipOval(
              // Clip the image to the circle
              child: Image.network(
                emp.img,
                fit: BoxFit.cover, // Use BoxFit.cover to fill the circle
                width: 80, // Explicitly set width
                height: 80, // Explicitly set height
                errorBuilder: (context, object, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.name), // Use emp.name
                Text("${emp.id}"), // Use emp.id
                Text(emp.department),
                TextButton(
                    onPressed: () {
                      showBottomSheet(
                        backgroundColor:
                            const Color.fromARGB(255, 222, 222, 222),
                        constraints: BoxConstraints.expand(),
                        context: context,
                        builder: (context) => Editscreen(
                          emp: emp,
                        ),
                      );
                    },
                    child: Text("Edit"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
