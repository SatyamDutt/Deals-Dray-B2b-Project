import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? homeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHomeData();
  }

  void fetchHomeData() async {
    final ApiService apiService = ApiService();
    final response = await apiService.getHomeDataWithoutPrice();

    setState(() {
      homeData = response['data'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 40,
                      onPressed: () {},
                      icon: Icon(Icons.menu),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey[350],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Colors.grey[350],
                                ),
                                child: Image.asset(
                                  'assets/logo.jpg',
                                  height: 40,
                                  width: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[350],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: EdgeInsets.all(10),
                                    hintText: 'Search here',
                                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                              iconSize: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_none_rounded),
                      iconSize: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              buildBannerSlider(homeData!['banner_one']),
              SizedBox(height: 10),

              buildCategoryList(homeData!['category']),
              SizedBox(height: 10),

              buildProductList(homeData!['products']),
              SizedBox(height: 10),

              buildBannerSlider(homeData!['banner_two']),
              SizedBox(height: 10),

              buildProductList(homeData!['new_arrivals'], title: "New Arrivals"),
              SizedBox(height: 10),

              buildBannerSlider(homeData!['banner_three']),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.red),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.category),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.local_offer),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Row(
          children: [
            Icon(Icons.chat),
            SizedBox(width: 5),
            Text("Chat"),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget buildBannerSlider(List<dynamic> banners) {
    return CarouselSlider(
      options: CarouselOptions(height: 150.0, autoPlay: true),
      items: banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Image.network(
                banner['banner'],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildCategoryList(List<dynamic> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.map((category) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        category['icon'],
                        width: 50,
                        height: 50,
                      ),
                      SizedBox(height: 5),
                      Text(category['label']),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductList(List<dynamic> products, {String? title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 10),
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        products[index]['icon'],
                        width: 150,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 5),
                      Text(
                        products[index]['label'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        products[index]['SubLabel'] ?? '',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "${products[index]['offer']} OFF",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

