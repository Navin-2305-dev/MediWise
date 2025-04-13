class DoctorModel {
  final String name;
  final String specialization;
  final String imageUrl;
  final double rating;
  final String biography;
  final List<Map<String, String>> history;
  final List<Map<String, String>> appointments;

  DoctorModel({
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.rating,
    required this.biography,
    required this.history,
    required this.appointments,
  });
}

List<DoctorModel> getDoctors() {
  return [
    DoctorModel(
      name: "Sathyabama General Hospital",
      specialization: "General",
      imageUrl:
          "https://lh5.googleusercontent.com/p/AF1QipPm-Y18vSkEvZXng8QfVoRCt2ZU3oeOzyznGL5G=w533-h240-k-no",
      rating: 3.9,
      biography:
          "Sathyabama has a General Hospital with medical staff, paramedical staff which serves our staff, students and general public. It also has a pharmacy, a laboratory, sophisticated diagnostic services (such as radiology and angiography), physical therapy departments, dental services, an obstetrical unit (a nursery and a delivery room), operating rooms, recovery rooms, an outpatient department, and an emergency department. Separate medical rooms are present inside the institute for the students and staffs. Doctors and nurses are present 24X7 in case of emergency.  Full Time Medical officers are available in the Campus to take care of students. ",
      history: [
        {'title': 'Medical Education', 'subtitle': 'University of Neurology'},
      ],
      appointments: [
        {'day': 'Monday', 'date': 'June 15th'},
      ],
    ),
    DoctorModel(
      name: "Semmancheri primary health centre",
      specialization: "General",
      imageUrl:
          "https://lh5.googleusercontent.com/p/AF1QipOgUXhgJkuGdrFFoubvi95gJL8yrnHXj_2D8ts-=w408-h550-k-no",
      rating: 4.0,
      biography:
          "It serves as a vital healthcare facility for the local community, providing essential medical services. The PHC is staffed with a medical officer, a block extension educator, a female health assistant, a compounder, a driver, and a laboratory technician.",
      history: [
        {'title': 'Medical Education', 'subtitle': 'University of Cardiology'},
      ],
      appointments: [
        {'day': 'Wednesday', 'date': 'June 17th'},
      ],
    ),
    // Add more DoctorModel instances here following the same pattern
    // Example empty template:
    DoctorModel(
      name: "Dr.Kamakshi Memorial Hospitals",
      specialization: "Multispecialty (Cancer, Cardiac care, etc.)",
      imageUrl:
          "https://static.toiimg.com/thumb/msid-83240521,width-1070,height-580,overlay-toi_sw,pt-32,y_pad-40,resizemode-75,imgsize-1259836/83240521.jpg",
      rating: 4.5,
      biography:
          "A 300-bed tertiary healthcare provider specializing in cancer and cardiac care. Equipped with advanced technology and globally trained specialists, it offers comprehensive medical services",
      history: [
        {
          'title': 'Comprehensive Tertiary Care',
          'subtitle': 'Specialists in Cancer & Cardiac Services'
        },
      ],
      appointments: [
        {'day': 'Thursday', 'date': 'July 18th'},
      ],
    ),
    DoctorModel(
      name: "Astra Speciality Hospital",
      specialization: "Multispecialty",
      imageUrl:
          "https://lh5.googleusercontent.com/p/AF1QipN0hPfp2sUK3ZRyejrtt99jzmnAIoazij1KXzYT=w408-h544-k-no",
      rating: 4.0,
      biography:
          "Known for cutting-edge technology and affordable healthcare, Astra provides multispecialty services, including orthopedics, gastroenterology, and pediatrics.",
      history: [
        {
          'title': 'Affordable Multispecialty Care',
          'subtitle': 'Advanced Orthopedics, Pediatrics & More'
        },
      ],
      appointments: [
        {'day': 'Friday', 'date': 'August 19th'},
      ],
    ),
    DoctorModel(
      name: "KT Medicare Clinic",
      specialization: "Diabetology, Dietetics, General Practice",
      imageUrl:
          "https://lh5.googleusercontent.com/p/AF1QipNSY-950T2VDJET3Ao1lChSoQq_NnjSfS7uvATq=w408-h544-k-no",
      rating: 4.9,
      biography:
          "Focused on diabetes management, dietetics, and general practice, this clinic offers personalized care for chronic conditions and preventive health.",
      history: [
        {
          'title': 'Personalized Health Solutions',
          'subtitle': 'Diabetology, Dietetics, and General Practice'
        },
      ],
      appointments: [
        {'day': 'Saturday', 'date': 'September 20th'},
      ],
    ),
    DoctorModel(
      name: "ES Hospital",
      specialization: "Multispecialty",
      imageUrl:
          "https://lh5.googleusercontent.com/p/AF1QipPUJ0k1YtssAQaYrp4XCy32eJj1p9VIJoDYHVor=w408-h306-k-no",
      rating: 4.7,
      biography:
          "It provides comprehensive medical care across various specialties, including cardiology, neurology, orthopedics, nephrology, and pediatrics .",
      history: [
        {
          'title': 'Excellence in Multispecialty Healthcare',
          'subtitle': 'Cutting-edge Technology & Services Since 2007'
        },
      ],
      appointments: [
        {'day': 'Monday', 'date': 'October 21th'},
      ],
    ),
  ];
}

final List<DoctorModel> doctorsList = getDoctors();
