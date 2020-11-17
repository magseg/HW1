#include <vector>
#include <thread>
#include <iostream>
#include <mutex>
using namespace std;
static bool flag = false;
static mutex mute;
static void f1(int i, int n, int m, int** arr, int thread_count)
{
	int j = i;
	while (true)
	{
		mute.lock();
		if (j / m >= n || j % m >= m)
		{
			mute.unlock();
			break;
		}
		if (arr[j / m][j % m] == 0)
		{
			cout << "Thread " << i << ". Cell " << j / m << "," << j % m << " is empty!";
			cout << endl;
			j += thread_count;
			mute.unlock();
		}
		else
		{
			cout << "Thread " << i << ". Cell " << j / m << "," << j % m << " is FULL OF TRESURES!";
			cout << endl;
			flag = true;
			mute.unlock();
			break;
		}
	}
}
int main()
{
	int thread_count;
	cout << "Enter the number of teams:\n";
	cin >> thread_count;
	int m, n;
	cout << "Enter the size of the island (N x M meters):\n";
	cin >> n;
	cin >> m;
	cout << "Generate treasure:\n";
	int** arr = new int* [n];
	int rand_n = rand() % n;
	int rand_m = rand() % m;

	for (int i = 0; i < n; i++)
	{
		arr[i] = new int[m];
	}

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < m; j++)
		{
			if (i == rand_n && j == rand_m)
			{
				arr[i][j] = 1;
			}
			else
			{
				arr[i][j] = 0;
			}
			cout << arr[i][j] << "\t";
		}
		cout << endl;
	}

	vector<thread> threads(thread_count);

	for (int i = 0; i < thread_count; i++)
	{
		threads[i] = thread(f1, i, n, m, arr, thread_count);
	}
	for (int i = 0; i < thread_count; i++)
	{
		threads[i].join();
	}

	for (int i = 0; i < n; i++)
	{
		delete[] arr[i];
	}
	delete[] arr;
	return 0;
}