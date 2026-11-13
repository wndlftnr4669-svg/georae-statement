-- 오늘전표 웹 버전: Supabase SQL Editor에 붙여넣고 Run
-- 자료 저장 칸(stores)을 만들고, 각자 자기 자료만 읽고 쓰게 막는다.
insert into storage.buckets (id, name, public, file_size_limit)
values ('stores', 'stores', false, 52428800)
on conflict (id) do nothing;

create policy "ojp own read"   on storage.objects for select to authenticated
  using (bucket_id = 'stores' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "ojp own insert" on storage.objects for insert to authenticated
  with check (bucket_id = 'stores' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "ojp own update" on storage.objects for update to authenticated
  using (bucket_id = 'stores' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'stores' and (storage.foldername(name))[1] = auth.uid()::text);
create policy "ojp own delete" on storage.objects for delete to authenticated
  using (bucket_id = 'stores' and (storage.foldername(name))[1] = auth.uid()::text);
