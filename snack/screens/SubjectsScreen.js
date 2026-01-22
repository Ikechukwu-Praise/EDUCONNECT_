// snack/screens/SubjectsScreen.js
import React from 'react';
import { View, Text, ScrollView, TouchableOpacity } from 'react-native';
import TopicCard from '../components/TopicCard';

export default function SubjectsScreen({ navigate }) {
  const [topics, setTopics] = React.useState([]);
  const [loading, setLoading] = React.useState(false);
  const defaultCountry = 'United States';

  React.useEffect(() => {
    let mounted = true;
    const load = async () => {
      setLoading(true);
      try {
        const { data, error } = await (await import('../lib/supabase')).supabase.from('subjects_by_country').select('subject').eq('country', defaultCountry);
        if (error) {
          console.warn('Failed to load subjects', error.message);
          if (mounted) setTopics([]);
        } else if (mounted) {
          setTopics(data.map(r => r.subject));
        }
      } catch (err) {
        console.warn(err);
      } finally { if (mounted) setLoading(false); }
    };
    load();
    return () => { mounted = false; };
  }, []);

  return (
    <ScrollView contentContainerStyle={{padding:20}}>
      <Text style={{fontSize:22,fontWeight:'700',marginBottom:12}}>Subjects ({defaultCountry})</Text>
      {loading && <Text>Loading...</Text>}
      {!loading && topics.length === 0 && <Text style={{color:'#666'}}>No subjects found.</Text>}
      {topics.map((t, i) => (
        <TopicCard key={i} title={t} onPress={() => navigate('resources')} />
      ))}

      <TouchableOpacity onPress={() => navigate('home')} style={{marginTop:20}}>
        <Text style={{color:'#999'}}>Back</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}
