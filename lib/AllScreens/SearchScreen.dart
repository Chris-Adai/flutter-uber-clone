import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/AllWidget/Divider.dart';
import 'package:flutter_uber_clone/Assistants/requestAssistant.dart';
import 'package:flutter_uber_clone/DataHandler/appData.dart';
import 'package:flutter_uber_clone/Models/placePrediction.dart';
import 'package:flutter_uber_clone/configMaps.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUpTextEditingController=TextEditingController();
  TextEditingController dropOfftextEditingController=TextEditingController();

  List<PlacePrediction> placePredictionList=[];

  @override
  Widget build(BuildContext context) {

    String placeAddress=Provider.of<AppData>(context).picUpLocation.placeName??"";
    pickUpTextEditingController.text=placeAddress;

    return Scaffold(
        body: Column(
          children: [
            Container(
              height: 215.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25.0,top: 25.0,right: 25.0,bottom: 20.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height:5.0 ,),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap:(){Navigator.pop(context);},
                            child: Icon(Icons.arrow_back)),
                        Center(
                          child: Text(
                            "Set Drop Off",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Brand-Bold"
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16.0,),

                    Row(
                      children: [
                        Image.asset("images/pickicon.png",height: 16.0,width: 16.0,),
                        SizedBox(height: 18.0,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickUpTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "PickUp Location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10.0,),

                    Row(
                      children: [
                        Image.asset("images/desticon.png",height: 16.0,width: 16.0,),
                        SizedBox(height: 18.0,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (val){
                                  findPlace(val);
                                },
                                controller: dropOfftextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Where to go",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11.0,top: 8.0,bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),

            //title for display prediction
            SizedBox(height: 10.0,),
            (placePredictionList.length>0)
                ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                  child:ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context,index){
                      return PredictionTile(placePrediction: placePredictionList[index],);
                    },
                    separatorBuilder: (BuildContext context,int index)=>DividerWidget(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ) ,
                 )
                : Container(),
          ],
        ),
    );
  }

  void findPlace(String placeName) async
  {
    if(placeName.length>1){
        String autocompleteUrl="https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:pk";
        var res=await RequestAssistant.getRequest(autocompleteUrl);

        if(res=="failed")
          {
            return;
          }
        if(res["status"]=="OK"){
          var predictions=res["predictions"];
          
          var placeList=(predictions as List).map((e) => PlacePrediction.fromJson(e)).toList();
          setState(() {
            placePredictionList=placeList;
          });
        }
    }
  }

}

class PredictionTile extends StatelessWidget {

  final PlacePrediction placePrediction;
  PredictionTile({Key key,this.placePrediction}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(width: 10.0,),
          Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(width: 14.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Text(placePrediction.main_text,overflow:TextOverflow.ellipsis,style: TextStyle(
                      fontSize: 16.0,
                    ),
                    ),
                    SizedBox(height: 3.0,),
                    Text(placePrediction.secondary_text,overflow: TextOverflow.ellipsis,style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey
                    ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 10.0,),
        ],
      ),
    );
  }
}

