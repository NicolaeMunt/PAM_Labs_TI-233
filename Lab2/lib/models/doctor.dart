class Doctor {
  final String name;
  final String specialty;
  final String imagePath;
  final String address;
  final String distance;
  final double price;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.imagePath,
    this.address = '',
    this.distance = '',
    this.price = 0,
  });
}

class HealthService {
  final String label;
  final String iconPath;

  const HealthService(this.label, this.iconPath);
}

const upcomingDoctor = Doctor(
  name: 'Dr. Richar Kandowen',
  specialty: 'Child Specialist',
  imagePath: 'assets/images/dr_richar_kandowen.jpg',
  price: 120,
);

const appointmentDoctor = Doctor(
  name: 'Dr.Upul',
  specialty: 'Denteeth',
  imagePath: 'assets/images/dr_upul.jpg',
  price: 120,
);

const nearbyDoctors = [
  Doctor(
    name: 'Dr. Emmly Lestriyno',
    specialty: 'General Practitioner',
    imagePath: 'assets/images/dr_emmly_lestriyno.jpg',
    address: '3167 Durgan Shores',
    distance: '500M',
    price: 90,
  ),
  Doctor(
    name: 'Dr. Sonja Liffel',
    specialty: 'Dental Specialist',
    imagePath: 'assets/images/dr_sonja_liffel.jpg',
    address: '950 Sigrid Port',
    distance: '755M',
    price: 120,
  ),
];

const healthServices = [
  HealthService('Tooth', 'assets/images/tooth.png'),
  HealthService('Eye', 'assets/images/eye.png'),
  HealthService('Lungs', 'assets/images/lungs.png'),
  HealthService('Ear', 'assets/images/ear.png'),
];
