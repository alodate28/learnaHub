// ==============================
// Courses Data
// بيانات الكورسات الوهمية (Static Data)
// ==============================

import '../models/course.dart';

const List<Course> allCourses = [
  Course(
    id: '1',
    title: 'Flutter Development Bootcamp',
    instructor: 'Angela Yu',
    category: 'Programming',
    description: 'Learn Flutter from scratch and build beautiful cross-platform apps.',
    lessons: 28,
    duration: '14h 30m',
    rating: 4.8,
    icon: '📱',
  ),
  Course(
    id: '2',
    title: 'UI/UX Design Fundamentals',
    instructor: 'Sarah Johnson',
    category: 'Design',
    description: 'Master the principles of user interface and user experience design.',
    lessons: 20,
    duration: '10h 00m',
    rating: 4.7,
    icon: '🎨',
  ),
  Course(
    id: '3',
    title: 'Python for Data Science',
    instructor: 'Jose Portilla',
    category: 'Data Science',
    description: 'Analyze data and build machine learning models using Python.',
    lessons: 35,
    duration: '22h 15m',
    rating: 4.9,
    icon: '🐍',
  ),
  Course(
    id: '4',
    title: 'Web Development with React',
    instructor: 'Maximilian Schwarzmüller',
    category: 'Programming',
    description: 'Build modern web apps with React, Hooks, and the Context API.',
    lessons: 30,
    duration: '18h 45m',
    rating: 4.6,
    icon: '⚛️',
  ),
  Course(
    id: '5',
    title: 'Digital Marketing Mastery',
    instructor: 'Neil Patel',
    category: 'Business',
    description: 'Grow your brand online using SEO, social media, and ads.',
    lessons: 18,
    duration: '9h 00m',
    rating: 4.5,
    icon: '📊',
  ),
  Course(
    id: '6',
    title: 'Cybersecurity Essentials',
    instructor: 'Dr. Chuck Easttom',
    category: 'Security',
    description: 'Understand threats, vulnerabilities, and how to protect systems.',
    lessons: 24,
    duration: '12h 30m',
    rating: 4.7,
    icon: '🔒',
  ),
  Course(
    id: '7',
    title: 'iOS App Development with Swift',
    instructor: 'Paul Hudson',
    category: 'Programming',
    description: 'Build native iOS apps using Swift and UIKit.',
    lessons: 26,
    duration: '15h 20m',
    rating: 4.8,
    icon: '🍎',
  ),
  Course(
    id: '8',
    title: 'Graphic Design with Figma',
    instructor: 'Daniel Scott',
    category: 'Design',
    description: 'Design stunning interfaces using Figma from beginner to pro.',
    lessons: 22,
    duration: '11h 00m',
    rating: 4.6,
    icon: '✏️',
  ),
];

const List<String> categories = [
  'All', 'Programming', 'Design', 'Data Science', 'Business', 'Security',
];
