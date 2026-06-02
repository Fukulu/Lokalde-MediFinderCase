// MediFinder

// Mimari Tercihler
// - MVVM pattern: View, ViewModel ve Model katmanları net ayrıldı. ViewModel; JSON dummy datayı yükler, filtreleme/arama/sayfalama gibi iş mantığını yönetir.
// - SwiftUI bileşen yaklaşımı: Görsel ve etkileşimli parçalar Components altında toplanarak tekrar kullanılabilir hale getirildi (örn. CustomSearchBar, FilterChipsBar, FloatingTabBar, ProviderGridCard, FilterDropdown, CustomNavigationBar).

// State Yönetimi
// - SwiftUI Observation (@Observable, @Environment) kullanıldı. ViewModel ve LanguageManager çevresel olarak enjekte edilerek tek kaynaktan durum yönetimi sağlandı.
// - Arama metni, seçili filtreler, seçili tab ve sayfalama durumları tek bir ViewModel üzerinden yönetildi. View’lar sadece UI durumunu yansıtıyor.

// Kod Organizasyonu ve Yeniden Kullanılabilirlik
// - View’lar View klasörü altında, küçük ve odaklı bileşenler Components klasörü altında toplandı.
// - Ortak UI parçaları ayrı komponentler olarak soyutlandı; aynı desen farklı ekranlarda kolayca kullanılabilir.

// Navigasyon Kurgusu
// - Ana akış HomePage üzerinden yönetilir. Alt kısımda 3 ana tab: Doctor, Hospital, Vet.
// - Her tab kendi kategori filtresini tetikler. Sağlanan filtreler sheet ile açılan FilterDropdown üzerinden seçilir.
// - Detay sayfası (ProviderDetailView) sheet ile sunulur; ayarlar (SettingsView) ayrı sheet olarak açılır.

// Dil ve Yerelleştirme
// - LanguageManager ile uygulama dili (English/Türkçe) yönetilir. SettingsView üzerinden dil değiştiğinde UI güncellenir.
// - FilterChipsBar metinleri ve FilterDropdown başlıkları Text tabanlı yerelleştirme ile anında güncellenir.
// - CustomSearchBar placeholder’ları manuel olarak LanguageManager.currentLanguage’a göre İngilizce/Türkçe döndürülür.

// Null / Eksik Veri Yönetimi
// - JSON’dan gelebilecek boş veya eksik alanlar için if let / optional kontrolleri uygulanır.
// - UI tarafında eksik veri için uygun placeholder/görseller gösterilir.

// Loading, Empty ve Error State’leri
// - Yükleme: İlk veri yüklenirken ve sayfalama sırasında ProgressView ile görsel geri bildirim.
// - Empty: Filtre/arama sonucunda veri yoksa “No Results Found” ve “Clear All Filters” aksiyonu sunulur.
// - Error: Hata mesajı ve “Retry” butonu ile yeniden deneme akışı.

// Kod Okunabilirliği ve Sürdürülebilirlik
// - Küçük, tek sorumluluklu View’lar ve ViewModel fonksiyonları.
// - Açık isimlendirme, yorum satırları ve log çıktılarını (print) ayıklamaya uygun yapı.
// - Bileşen tabanlı mimari ile yeni özellik ekleme/çıkarma kolaydır.

// Kurulum ve Çalıştırma
// - Xcode 15+ / 16+ (projeye uygun sürüm) ile açın.
// - Derleyip çalıştırın. Dummy JSON verileri uygulama içinde yüklenecektir.

// Önemli Teknik Kararlar (Kısa Notlar)
// - MVVM ile test edilebilir ve genişletilebilir mimari.
// - Observation ile modern ve sade state yönetimi.
// - Component bazlı UI ile yeniden kullanılabilirlik.
// - Yerelleştirme: Text bazlı başlıklar ve LanguageManager tabanlı dinamik placeholder’lar.
