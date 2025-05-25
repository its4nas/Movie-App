import 'package:flutter/material.dart';


class VerticalCardScroller extends StatelessWidget {
  final List<dynamic> movies;
  const VerticalCardScroller({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: List.generate(movies.length, (index){
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network('https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                          width: 120,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['title'].split(' ').asMap().entries.map((entry) {
                              if (entry.key > 0 && entry.key % 4 == 0) {
                                return '\n${entry.value}';
                              }
                              return entry.value;
                            }).join(' '),
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.person_2_rounded, color: Colors.grey,),
                              const SizedBox(width: 5),
                              Text(movie['popularity'].toString(), style: const TextStyle(fontSize: 12),),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.star_rounded, color: Colors.yellow,),
                              const SizedBox(width: 5),
                              Text(movie['vote_average'].toString(), style: const TextStyle(fontSize: 12),),
                            ],
                          ),
                        ]
                      ),
                    ]
                  ),
                ),
              ),
            );
          }),
      ),
    );
  }
}

