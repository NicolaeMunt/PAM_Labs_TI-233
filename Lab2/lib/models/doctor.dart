class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;
  final String address;
  final String distance;
  final double price;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.imageUrl,
    this.address = '',
    this.distance = '',
    this.price = 0,
  });
}

class HealthService {
  final String label;
  final String emoji;

  const HealthService(this.label, this.emoji);
}

const upcomingDoctor = Doctor(
  name: 'Dr. Richar Kandowen',
  specialty: 'Child Specialist',
  imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
  price: 120,
);

const appointmentDoctor = Doctor(
  name: 'Dr.Upul',
  specialty: 'Denteeth',
  imageUrl: 'https://randomuser.me/api/portraits/men/75.jpg',
  price: 120,
);

const nearbyDoctors = [
  Doctor(
    name: 'Dr. Emmly Lestriyno',
    specialty: 'General Practitioner',
    imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
    address: '3167 Durgan Shores',
    distance: '500M',
    price: 90,
  ),
  Doctor(
    name: 'Dr. Sonja Liffel',
    specialty: 'Dental Specialist',
    imageUrl: 'https://randomuser.me/api/portraits/men/46.jpg',
    address: '950 Sigrid Port',
    distance: '755M',
    price: 120,
  ),
];

const healthServices = [
  HealthService('Tooth', '🦷'),
  HealthService('Eye', '👁️'),
  HealthService('Lungs', '🫁'),
  HealthService('Ear', '👂'),
];
